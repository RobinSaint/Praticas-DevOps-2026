# Relatório Técnico: Atividade Prática de Sistemas Distribuídos

## Questão 01: Balanceamento de Carga e Conceitos

* ### **a) Como o Nginx distribui as requisições? Qual algoritmo?**
  As requisições são distribuídas de forma cíclica e sequencial. O algoritmo é o **Round-Robin** por padrão (definido no bloco `upstream` do nginx.conf). Sua função é encaminhar a primeira requisição para o `worker1`, a segunda para o `worker2`, a terceira para o `worker3`, e reiniciar o ciclo em seguida.

* ### **b) O que o campo 'worker' representa e como o Docker garante a distinção?**
  O campo `worker` mostra o valor retornado pelo comando  `socket.gethostname()`, que dentro de um contêiner Docker equivale ao ID do contêiner ou ao `container_name`. O Docker garante essa distinção isolando cada contêiner em seu próprio **Namespace de UTS (Unix Timesharing System)**, permitindo que cada processo enxergue um nome de host único.

* **c) Diferença entre Sistema Distribuído e Paralelo. Onde a prática se enquadra?**
  * **Sistemas Paralelos:** Compartilham a mesma memória física e relógio (fortemente acoplados), para dividir uma tarefa de computação intensa em várias CPUs de uma mesma máquina.
  * **Sistemas Distribuídos:** São nós que não compartilham memória nem relógio físico (fracamente acoplados) que se comunicam apenas via troca de mensagens na rede.
  * A prática é um **Sistema Distribuído**. Cada worker é um nó isolado com seu próprio acesso a uma rede e sistema de arquivos, coordenados por um balanceador de carga através do protocolo HTTP.

---

## Questão 02: Redes e Service Discovery

* ### **d) Por que se comunicam pelo nome e não por IP fixo?**
  Devido ao mecanismo de **Service Discovery** nativo do Docker. Quando contêineres estão conectados a uma rede bridge personalizada, o Docker altera e ativa um servidor DNS interno. Esse DNS resolve automaticamente o nome do serviço (ex: `worker1`) para o endereço IP privado dinâmico alocado para aquele contêiner.

* **e) Papel do driver 'bridge' e uma alternativa.**
  * **Papel:** O driver `bridge` cria uma rede virtual privada interna no host, permitindo que os contêineres conectados se comuniquem e usem NAT (Network Address Translation) para acessar a internet (rede externa).
  * **Alternativa:** O driver **Overlay**. É utilizado em clusters multi-host (como Docker Swarm), permitindo a comunicação nativa e segura entre contêineres rodando em máquinas físicas ou virtuais distintas.

* ### **f) Como o isolamento contribui para a segurança?**
  O isolamento garante que apenas os contêineres explicitamente atrelados à rede `rede-distribuida` consigam acessar/enviar pacotes entre si. Outros contêineres rodando no mesmo host (na rede bridge padrão, por exemplo) são incapazes de acessar ou coletar os dados dos contêineres dessa rede sem autorização.

---

## Questão 03: Tolerância a Falhas e SPOF

* ### **g) O que aconteceu após a remoção de worker2? O sistema continuou funcionando?**
  O Nginx detectou que o `worker2` falhou em responder e redireciona automaticamente as requisições para os nós que permanecem ativos: (`worker1` e `worker3`), trazendo um pouco de atraso inicialmente, mas sim, funcionou normalmente.

* **h) Definição de Tolerância a Falhas e como foi demonstrada.**
  * **Definição:** É a capacidade de um sistema manter a entrega de seus serviços (mesmo que com capacidade de processar menos) diante da falha de um ou mais de seus componentes ou microsserviços.
  * **Demonstração:** Ao executar o comando `docker stop worker2`, embora a infraestrutura tenha perdido uma parte de sua capacidade computacional (um dos nós), a aplicação continuou 100% disponível através dos outros nós.

* #### **i) Comportamento se todos os workers caírem? O que revela sobre o SPOF?**
  Se todos caírem, o Nginx retornará um erro HTTP **502 Bad Gateway**. Isso revela que, embora a camada de aplicação seja resiliente, o **Nginx (Load Balancer) é o Ponto Único de Falha (SPOF)** da arquitetura atual. Se o contêiner do Nginx falhar ou cair, nenhum cliente conseguirá acessar o sistema, independentemente de quantos workers estejam disponíveis e ativos.

---

## Questão 04: Transparência e Escalabilidade

* #### **j) O que é transparência e quais formas estão presentes aqui?**
  Transparência é a ocultação da separação física e da complexidade dos componentes distribuídos para o usuário, fazendo o sistema parecer um ecossistema único e centralizado, conforme requisitado pelo cliente/usuário. Nesta aplicação temos:
  * **Transparência de Localização:** O usuário não sabe em qual IP ou local geográfico os workers rodam; apenas conhece o ponto de entrada único do ambiente via navegador (`http://localhost/`).
  * **Transparência de Acesso:** A forma de acessar o recurso é idêntica (via requisições HTTP REST), ocultando as linguagens ou tecnologias internas utilizadas.
  * **Transparência de Replicação:** O cliente não faz ideia de que podem existir instâncias idênticas respondendo por trás de um proxy ou mais.
  * **Transparência de Falha:** Se um `worker` ou mais workers caíram, e o usuário não recebeu mensagens de erro, o sistema ocultou a falha redirecionando o tráfego para outra hospedagem ou site.

* #### **k) Se um worker consumisse 100% de CPU, como o Round-Robin reagiria? Mecanismo alternativo?**
  O Nginx continuaria enviando requisições para esse worker conforme o ciclo e repetidamente, pois o Round-Robin puro baseia-se apenas na ordem de chegada dos dados e no envio direto. O uso do algoritmo no Nginx **Least_conn** (direciona para quem tem menos conexões ativas) seria útll ou as checagens HTTP de saúde dinâmicas (*HTTP health checks*) que removem temporariamente nós lentos.

* #### **l) Como imagens imutáveis favorecem a escalabilidade horizontal?**
  Como a imagem Docker do worker é estática e contém o SO reduzido, dependências e código blindados, e é capaz de ser executada em qualquer máquina por ser um arquivo .iso (imagem), nós podemos instanciar novas réplicas idênticas em segundos. Não há risco de variação de comportamento por configurações externas, permitindo qualquer escalabilidade horizontal.

---

## Questão 05: Estado e Orquestradores

* **m) Diferença entre Escalabilidade Vertical e Horizontal. O que foi feito?**
  * **Vertical (Scale-up):** Adicionar mais poder de hardware (mais CPU, mais RAM) à máquina atual.
  * **Horizontal (Scale-out):** Adicionar mais máquinas ou instâncias ao sistema compartilhado.
  * Adicionar o `worker4` é um exemplo de **Escalabilidade Horizontal**, pois expandimos a capacidade de vazão do sistema criando um novo nó distribuído independente (uma nova instância, que utiliza um mesmo hardware).

* #### **n) Como Docker Swarm ou Kubernetes resolveriam a edição manual do `nginx.conf`?**
  Esses orquestradores possuem controladores de **Ingress** e serviços nativos com balanceamento de carga integrado. Em vez de fixar IPs ou nomes de réplicas/instâncias num arquivo de configuração estático, define-se uma política declarativa (ex: `replicas: 5`). O orquestrador cria os contêineres e atualiza o roteamento interno automaticamente por meio de endpoints virtuais dinâmicos.

* **o) Desafios de compartilhar estado (sessão/contadores) e resoluções no mercado.**
  * **Desafios:**
    1. *Inconsistência de dados:* Como as requisições rotacionam entre os workers, se o usuário logar no `worker1`, e sua próxima requisição cair no `worker3`, o usuário será tratado como deslogado por falta de persistência de sessão.
    2. *Condições de Corrida:* Múltiplos workers podem incrementar um contador simultaneamente, mas podem gerar dados corrompidos facilmente caso possua falta de sincronismo.
  * **Reluções no mercado:** Utilização de bancos de dados em memória, centralizados e distribuídos, como o **Redis** ou **Memcached** (para armazenar sessões de forma *stateless*), ou soluções de persistência de dados robustas compartilhadas na rede do cluster.
 
  * Link para os Screenshots: https://docs.google.com/document/d/1afSVk8k4Wtnda42HsxpdPaXdCFqiXUY6FfEAV8O3XTM/edit?usp=sharing
