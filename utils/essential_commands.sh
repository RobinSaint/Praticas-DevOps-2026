#!/usr/bin/env bash
# ------------------------------------------------------------------------ #
# Script Name:   essential_commands.sh
# Description:   Demonstrates essential DevOps commands
# Site:          https://github.com/Robin/Praticas-DevOps-2026
# Written by:    Robin
# Maintenance:   Robin
# ------------------------------------------------------------------------ #
# Usage:         
#       $ ./essential_commands.sh
# ------------------------------------------------------------------------ #
# Repository:    
#       Path: utils/essential_commands.sh
# ------------------------------------------------------------------------ #
# History:       
#        v1.0 15/04/2026 - Robin:
#           - Initial version
# ------------------------------------------------------------------------ #

# Variables --------------------------------------------------------------- #
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'
readonly TEST_FILE="temp_devops_test.txt"

# Functions --------------------------------------------------------------- #

print_section() {
    echo -e "${BLUE}======================================================${NC}"
    echo -e "${YELLOW}  $1 ${NC}"
    echo -e "${BLUE}======================================================${NC}"
}

print_command() {
    echo -e "${GREEN}Executing: $1 ${NC}"
}

# Main Code --------------------------------------------------------------- #

clear
print_section "ESSENTIAL DEVOPS COMMANDS DEMO"
echo ""

# 1. Comando pwd
print_section "1. pwd - Print Working Directory"
print_command "pwd"
echo "   Descrição: Mostra o diretório atual"
echo "   Help: pwd --help"
echo "   Exemplo:"
echo "   Diretório atual: $(pwd)"
echo ""

# 2. Comando date
print_section "2. date - Display date and time"
print_command "date"
echo "   Descrição: Exibe ou define data e hora do sistema"
echo "   Help: date --help"
echo "   Exemplo:"
echo "   Data atual: $(date)"
echo "   Data formatada: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 3. Comando touch
print_section "3. touch - Create/Update File"
print_command "touch $TEST_FILE"
touch "$TEST_FILE"
echo "   Descrição: Cria um arquivo vazio ou atualiza o timestamp"
echo "   Help: touch --help"
echo "   Exemplo: Arquivo '$TEST_FILE' criado com sucesso."
echo ""

# 4. Comando cat
print_section "4. cat - Concatenate and Display"
echo "DevOps TechSolutions - Lab 1.1" > "$TEST_FILE"
print_command "cat $TEST_FILE"
echo "   Descrição: Exibe o conteúdo de um arquivo"
echo "   Help: cat --help"
echo "   Conteúdo: $(cat "$TEST_FILE")"
echo ""

# 5. Comando grep
print_section "5. grep - Pattern Search"
print_command "grep 'DevOps' $TEST_FILE"
echo "   Descrição: Busca por padrões de texto"
echo "   Help: grep --help"
echo "   Resultado: $(grep 'DevOps' "$TEST_FILE")"
echo ""

# 6. Comando curl
print_section "6. curl - Client URL"
print_command "curl -I https://www.google.com"
echo "   Descrição: Transfere dados de ou para um servidor"
echo "   Help: curl --help"
echo "   Exemplo (Status Code): $(curl -s -I https://www.google.com | head -n 1)"
echo ""

# 7. Comando gzip
print_section "7. gzip - File Compression"
print_command "gzip -k $TEST_FILE"
gzip -k "$TEST_FILE"
echo "   Descrição: Comprime arquivos (formato .gz)"
echo "   Help: gzip --help"
echo "   Exemplo: Arquivo compactado $(ls $TEST_FILE.gz)"
echo ""

# 8. Comando chmod
print_section "8. chmod - Change Permissions"
print_command "chmod 600 $TEST_FILE"
chmod 600 "$TEST_FILE"
echo "   Descrição: Altera as permissões de acesso"
echo "   Help: chmod --help"
echo "   Exemplo: $(ls -l "$TEST_FILE")"
echo ""

# 9. Comando pgrep
print_section "9. pgrep - List Processes by Name"
print_command "pgrep bash"
echo "   Descrição: Busca PIDs de processos baseados no nome"
echo "   Help: pgrep --help"
echo "   PIDs do Bash: $(pgrep bash | xargs)"
echo ""

# 10. Comando ps
print_section "10. ps - Process Status"
print_command "ps aux | grep bash"
echo "   Descrição: Informações sobre processos ativos"
echo "   Help: man ps"
echo "   Exemplo: $(ps -s $$ | tail -n 1)"
echo ""

# 11. Comando df
print_section "11. df - Disk Free Space"
print_command "df -h ."
echo "   Descrição: Exibe o uso de espaço em disco"
echo "   Help: df --help"
echo "   Espaço na raiz: $(df -h / | tail -1)"
echo ""

# 12. Comando du
print_section "12. du - Disk Usage"
print_command "du -sh $TEST_FILE"
echo "   Descrição: Estima o uso de espaço de arquivos/diretórios"
echo "   Help: du --help"
echo "   Tamanho do teste: $(du -sh "$TEST_FILE")"
echo ""

# Cleanup
rm "$TEST_FILE" "$TEST_FILE.gz"

# ------------------------------------------------------------------------ #
# END #