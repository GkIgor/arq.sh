#!/bin/bash

#Informações de datas
ano=$(date +%Y | cut -c 3-4)    #Ano formato AA
mes=$(date +%m)                 #Mes formato MM
dia=$(date -d "yesterday" +%d)  #Dia formato DD

diabat=$(head -4 /patch/engineer/bk/mov24* | grep "DATA:" | awk '{ print $6 }' | cut -c1-2)
mesbat=$(head -4 /patch/engineer/bk/mov24* | grep "DATA:" | awk '{ print $6 }' | cut -c4-5)
anobat=$(head -4 /patch/engineer/bk/mov24* | grep "DATA:" | awk '{ print $6 }' | cut -c7-8)

#Linha de Comando
data=$1
fff=$(hostname | cut -c 8-10)

#Verificacoes
if [[ $(hostname) == database* ]]; then
	echo ''
	echo 'Este script deve ser executado apenas no servidor engineer'
	echo ''
	exit 3
fi

if [ "$data" != "$dia$mes$ano" ] && [ "$data" != "$diabat$mesbat$anobat" ]; then
	echo ''
    echo -e " data\e[32m $data \e[0minvalida. Insira a data do ultimo batimento no formato abaixo:"
	echo " arq.sh $dia$mes$ano"
	echo -e "\e[31m ERRO: 2 \e[31m"
	echo ''
    exit 2;
fi

#Funcoes
command() {
	clear
	echo " Abrindo o arquivo em   segundos."
	echo ''
	echo " Aguarde ou pressione qualquer tecla para continuar"
	echo ''
	
	for ((i=9; i > 0; i--))
		do
			echo -ne "\033[?25l" # Oculta o cursor
			tput cup 0 22; echo "$i"
			tput cup 5 1
			read -t 1 -n 1 skip || read -t 0.001 -n 1 skip
			if [[ $skip ]] || [[ $skip == $'\n' ]]; then
				echo -ne "\033[?25h" # Mostra o cursor
				break;
			fi
		
		done
		
	echo -ne "\033[?25h" # Mostra o cursor
	
	cat arq000$data >> /file.xml
	
	echo -e "\e[32m Finalizado. Caso tenha dado erro, tente novamente mais tarde. \e[0m"
}

searchFile() {

	echo ''
	echo -e "\e[32m arq000$data \e[0m nao encontrado em \033[35m /patch/arq.\e[0m"
	echo ''
	echo -e " Deseja abrir o \e[31m transfire\e[0m  para baixar o arquivo ( \e[32m arq000$data \e[0m)?";
	echo ''
	read -n 1 -p " Pressione 's' para abrir ou 'n' para cancelar: " input
	echo ''

	case "$input" in
		[Ss])
			echo ''
			echo -e "\e[5;42;30m Aguarde... \e[0m"
			echo ''
			sudo transfire.sh
			echo ''
			echo -e "\e[32m Finalizado. Caso tenha dado erro, tente novamente mais tarde. \e[0m"
			echo ''
			echo ''
			echo ''
			exit 0;
			;;
		[Nn])
			echo ''
			echo -e " Cancelado pelo usuario \e[31m ERRO: 130 \e[31m"
			echo ''
			exit 130;
			;;
		*)
			clear
			echo ''
			echo "\e[31m Entrada invalida. \e[31m"
			echo ''
			searchFile;
	esac

}

filearq() {
	
	if [ -a "arq000$data" ]; then command; else searchFile; fi
}

cd /patch/arq
filearq;

:<<COMMENT
OBS: Caso o cursor apresente erro, pode remover ou modificar o comando echo -ne  na funcao command.
E possivel corrigir o problema nas configuracoes do putty.
Se preferir, utilize o comando echo -ne "\033[?25h" diretamente na linha de comando.

Manter os creditos!
Dia 22/03/2023.
Licenca MIT.

Licença MIT

Copyright (c) 2023 Igor Ferreira See More

A permissão é concedida, gratuitamente, a qualquer pessoa que obtenha uma cópia
deste software e arquivos de documentação associados (o "Software"), para lidar
no Software sem restrições, incluindo, sem limitação, os direitos
usar, copiar, modificar, fundir, publicar, distribuir, sublicenciar e/ou vender
cópias do Software e para permitir que as pessoas a quem o Software é
munidos para o efeito, nas seguintes condições:

O aviso de direitos autorais acima e este aviso de permissão devem ser incluídos em todos os
cópias ou partes substanciais do Software.

O SOFTWARE É FORNECIDO "COMO ESTÁ", SEM GARANTIA DE QUALQUER TIPO, EXPRESSA OU
IMPLÍCITAS, INCLUINDO, SEM LIMITAÇÃO, AS GARANTIAS DE COMERCIALIZAÇÃO,
ADEQUAÇÃO PARA UM FIM ESPECÍFICO E NÃO VIOLAÇÃO. EM NENHUM CASO O
OS AUTORES OU DETENTORES DOS DIREITOS AUTORAIS SERÃO RESPONSÁVEIS POR QUALQUER REIVINDICAÇÃO, DANOS OU OUTROS
RESPONSABILIDADE, SEJA EM UMA AÇÃO DE CONTRATO, ILÍCITO OU DE OUTRA FORMA, DECORRENTE DE,
FORA DE OU EM CONEXÃO COM O SOFTWARE OU O USO OU OUTROS NEGÓCIOS NO
PROGRAMAS.

COMMENT