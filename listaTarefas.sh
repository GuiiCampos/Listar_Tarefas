#!/usr/bin/env bash

# listaTarefas - Gerencia uma lista de tarefas.

# Autor:       Guilherme Campos

# Manutenção:  Guilherme Campos

# ------------------------------------------------------------------------ #

# Um script que usa um arquivo de texto de banco de dados, para gerenciar uma lista de tarefas.

#  Exemplos:

#   ./listaTarefas.sh -a
#      - Neste exemplo o script vai adicionar algo a lista e mostrar a lista.
#   ./listaTarefas.sh -u
#      - Neste exemplo o script atualiza o status de uma tarefa já existente.
# ------------------------------------------------------------------------ #

# Histórico:

#   v1.0 16/10/2024, Guilherme Campos:

#       - Início do programa

#   v1.1 23/10/2024. Guilherme Campos:
#   	- Adicionando persistencia de dados
#   v1.2 23/10/2024. Guilherme Campos:
#   	- CRUD adicionado
#
# ------------------------------------------------------------------------ #

# Testado em:

#   bash 5.2.21

# ------------------------------- VARIÁVEIS ----------------------------------------- #

HELP="
 -h - help
 -a - adicionar
 -l - listar
 -r - remover
 -u - atualizar
"
SEP=:
ARQ_DB="tarefas.txt"
ARQ_TEMP=temp.$$

VERDE="\033[32m"
VERMELHO="\033[31m"

OPERACAO=0
#-------------------------------- TESTE -------------------------------------------- #

[ ! -e $ARQ_DB ] && echo -e "${VERMELHO}ERRO\e[0m, Arquivo não existe" && exit 1
[ ! -w $ARQ_DB ] && echo -e "${VERMELHO}ERRO\e[0m, Arquivo não tem permissão de escrita" && exit 1
[ ! -r $ARQ_DB ] && echo -e "${VERMELHO}ERRO\e[0m, Arquivo não tem permissão leitura" && exit 1

#------------------------------- FUNÇÔES -------------------------------------------- #
ReadTarefas () { #Organiza o print do DB todo
	local nome="$(echo $1 | cut -d $SEP -f 2)"
	local id="$(echo $1 | cut -d $SEP -f 1)" 
	local status="$(echo $1 | cut -d $SEP -f 3)"

	echo "ID $id: Nome: $nome"
	if [[ "$status" = "pendente" ]] 
	then
		echo -e "${VERMELHO}Status: $status\e[0m"
	else
		echo -e "${VERDE}Status: $status\e[0m"
	fi
}
ListaTarefas () { #Ordena e printa
	sort "$ARQ_DB" > "$ARQ_TEMP"
        mv "$ARQ_TEMP" "$ARQ_DB"

	while read -r atual
	do
		[ "$(echo $atual | cut -c1)" = "#" ] && continue
		[ ! "$atual" ] && continue
		ReadTarefas "$atual"
	done < "$ARQ_DB"
}
VerificaExistencia () { #verifica se o argumento existe no DB
	grep -i -q "$1$SEP" "$ARQ_DB"
}
CreateTarefa () { #Adiciona tarefas ao DB
	local nome="$(echo $1 | cut -d $SEP -f 2 )"
	
	if VerificaExistencia "$nome"
	then
	       echo -e "${VERMELHO}ERRO\e[0m, já existe essa tarefa"
        else
		echo "$*" >> "$ARQ_DB"	       
	fi
}


UpdateTarefa () { #Atualiza uma tarefa existente
	VerificaExistencia "$1" || return
	if [[ "$(grep $1$SEP $ARQ_DB | cut -d $SEP -f 3)" = "pendente" ]]
	then
		sed -i "/$1$SEP/ s/pendente/concluido/" $ARQ_DB
	fi
	if [[ "$(grep $1$SEP $ARQ_DB | cut -d $SEP -f 3)" = "concluido" ]]	
	then
		sed -i "/$1$SEP/ s/concluido/pendente/" $ARQ_DB
	fi

}

DeleteTarefa () { #Deleta uma tarefa
	VerificaExistencia "$1" || return
        grep -i -v "$1$SEP" "$ARQ_DB" > "$ARQ_TEMP"
        mv "$ARQ_TEMP" "$ARQ_DB"
}
# ------------------------------- EXECUÇÃO ----------------------------------------- #
while test -n "$1"
do
	case "$1" in
		-h) echo "$HELP" && exit 0							;;
		-a) OPERACAO=1 									;;#ADD
		-l) OPERACAO=2									;;#LISTA
		-r) OPERACAO=3									;;#REMOVE
		-u) OPERACAO=4									;;#ATUALIZA
		 *) echo -e "${VERMELHO}INVALIDO\e[0m, digite -h para ajuda" && exit 0		;;
	esac
	shift
done

case "$OPERACAO" in
	1) echo "Digite a tarefa a ser adicionada:" #Adicionar
		echo "Exemplo: 3:Cozinhar:pendente"
		read add 
		CreateTarefa "$add"
		;;                                                                  
	2) ListaTarefas		;; #Mostrar tudo
	3) echo "Digite o nome de alguma tarefa para exclui-la:" #REMOVE
		read del
		DeleteTarefa "$del"
		;;                          
	4) echo "Digite o nome da tarefa para mudar o status dela:"
	        read tarefa
		UpdateTarefa "$tarefa"	
		;;
esac
