#!/usr/bin/env bash

# listTarefas - Gerencia uma lista de tarefas.


# Site:       https://list.com

# Autor:      Guilherme Campos

# Manutenção:  Guilherme Campos


# ------------------------------------------------------------------------ #

# Um script que usa um arquivo de texto para gerenciar uma lista de tarefas.

#  Detalhe:
# 	Ainda não a persistencia de dados.
# 	Para ler as tarefas adicionadas, precisa obrigatoriamente passar os comandos -a -l
# 	Funcionalidade delete ainda não disponivel 

#  Exemplos:

#      $ ./listTarefas.sh -a -l

#      Neste exemplo o script vai adicionar algo a lista e mostrar a lista.

# ------------------------------------------------------------------------ #

# Histórico:

#

#   v1.0 16/10/2024, Guilherme Campos:

#       - Início do programa

#   v1.1 16/10/2024. Guilherme Campos:
#   	- adicionar e listar

# ------------------------------------------------------------------------ #

# Testado em:

#   bash 5.2.21

# ------------------------------- VARIÁVEIS ----------------------------------------- #

HELP="
 -h - help
 -a - adicionar
 -l - listar
 -r - remover
"
TAREFAS=()
ADD=0
LIST=0
#DELETE=0 #ainda não adicionado

# ------------------------------- EXECUÇÃO ----------------------------------------- #

while test -n "$1"
do
	case "$1" in
		-h) echo $HELP && exit 0	;;
		-a) ADD=1 			;;
		-l) LIST=1			;;
		-d) DELETE=1			;;
		*) echo "INVALIDO" && exit 0	;;
	esac
	shift
done

if [[ $ADD -eq 1 ]]; then
	while true; do
		echo "Adicione uma terefa (ou zero para parar): "
		read TAREFA
		if [[ "$TAREFA" == "0" ]]; then
			break
		fi
		TAREFAS+=("$TAREFA")
		echo "Tarefa Adicionada"
	done
fi

if [[ $LIST -eq 1 ]]; then
	for i in ${TAREFAS[@]}; do
		echo "$i"	
	done
fi
