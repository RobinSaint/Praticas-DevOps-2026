#!/usr/bin/env bash
# ------------------------------------------------------------------------ #
# Script Name:   backup-system.sh
# Description:   Automação de backup para laboratório de DevOps
# Site:          https://github.com/RobinSaint/Praticas-DevOps-2026
# Written by:    Robin
# Maintenance:   Robin
# ------------------------------------------------------------------------ #
# Usage:
#       $ ./backup-system.sh
# ------------------------------------------------------------------------ #
# History:        v1.0 15/04/2026, Robin:
#                - Inicialização do projeto e estrutura conforme protocolo
#                 v1.1 15/04/2026, Robin:
#                 - Adicionado tratamento de erros ($?) e validação de diretórios
# ------------------------------------------------------------------------ #

# VARIABLES -------------------------------------------------------------- #
# Pega o caminho absoluto do diretório onde o script está
DIRETORIO_ATUAL=$(dirname "$(readlink -f "$0")")
DATA_BACKUP=$(date +%Y-%m-%d_%H-%M)
LOG_FILE="$DIRETORIO_ATUAL/../logs/backup.log"

# FUNCTIONS -------------------------------------------------------------- #
# Thankfulness: Obrigado a Deus, e a Una e Santa, Igreja Católica, por sua divina Sabedoria e Perfeição.
#
# CODE ------------------------------------------------------------------- #
echo "[$DATA_BACKUP] Iniciando processo de backup..." >> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "Sucesso: Log gerado em $LOG_FILE"
else
    echo "Erro: Não foi possível gravar o log ($LOG_FILE)."
fi

# END -------------------------------------------------------------------- #