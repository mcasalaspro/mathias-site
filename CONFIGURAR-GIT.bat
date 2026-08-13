@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
title Configurar o Git

echo(
echo  ============================================
echo    CONFIGURAR O GIT
echo  ============================================
echo(

rem ---------- 1. o Git esta instalado? ----------
git --version >nul 2>&1
if errorlevel 1 goto sem_git

set "VERSAO="
for /f "tokens=3" %%A in ('git --version') do set "VERSAO=%%A"
echo  Git encontrado: versao !VERSAO!
echo  Recomendada:    2.55.0.windows.4 ou mais nova (corrige a CVE-2026-62960)
echo(
echo  Para atualizar depois, rode:  git update-git-for-windows
echo(

rem ---------- 2. nome e e-mail ----------
set "GITNOME="
set "GITEMAIL="
for /f "delims=" %%A in ('git config --global user.name 2^>nul') do set "GITNOME=%%A"
for /f "delims=" %%A in ('git config --global user.email 2^>nul') do set "GITEMAIL=%%A"

if not defined GITNOME goto pedir_nome
echo  Ja configurado como: !GITNOME! ^<!GITEMAIL!^>
echo(
set "TROCAR="
set /p "TROCAR=  Quer trocar? (s/N): "
if /i "!TROCAR!"=="s" goto pedir_nome
goto aplicar

:pedir_nome
echo(
echo  Estes dois dados ficam gravados no historico de cada alteracao.
echo  Use o mesmo e-mail da sua conta do GitHub.
echo(
set /p "GITNOME=   Seu nome: "
set /p "GITEMAIL=   Seu e-mail: "
if "!GITNOME!"=="" goto cancelado
if "!GITEMAIL!"=="" goto cancelado

:aplicar
echo(
echo  Aplicando as configuracoes...
echo(

git config --global user.name "!GITNOME!"
git config --global user.email "!GITEMAIL!"

rem Novos repositorios ja nascem com a branch "main", que e a que o GitHub usa.
git config --global init.defaultBranch main

rem Sem isso, um "git commit" sem mensagem abre o editor Vim, do qual e dificil sair.
git config --global core.editor "notepad"

rem Guarda o login do GitHub com seguranca, no Gerenciador de Credenciais do Windows.
git config --global credential.helper manager

rem Quebra de linha: Windows no seu disco, Unix no repositorio. E o padrao correto.
git config --global core.autocrlf true

rem Evita o aviso "divergent branches" toda vez que voce roda git pull.
git config --global pull.rebase false

rem Mostra acentos nos nomes de arquivo em vez de codigos tipo \303\247.
git config --global core.quotepath false

rem Permite caminhos longos, limitacao antiga do Windows que ainda aparece.
git config --global core.longpaths true

rem Envia so a branch atual, nunca todas de uma vez sem querer.
git config --global push.default simple

echo  ============================================
echo    PRONTO. Configuracao atual:
echo  ============================================
echo(
echo    Nome .............. !GITNOME!
echo    E-mail ............ !GITEMAIL!
for /f "delims=" %%A in ('git config --global init.defaultBranch')  do echo    Branch padrao ..... %%A
for /f "delims=" %%A in ('git config --global core.editor')         do echo    Editor ............ %%A
for /f "delims=" %%A in ('git config --global credential.helper')   do echo    Guardar login ..... %%A
for /f "delims=" %%A in ('git config --global core.autocrlf')       do echo    Quebra de linha ... autocrlf=%%A
echo(
echo    O arquivo com tudo isso fica em:
echo    %USERPROFILE%\.gitconfig
echo(
echo    Proximo passo: rode o PUBLICAR.bat.
echo(
goto fim

rem ============================================================
:sem_git
echo  [!] O Git nao esta instalado neste computador.
echo(
echo      Opcao 1 — instalador (recomendado):
echo        https://git-scm.com/download/win
echo        Baixe o arquivo Git-2.55.0.4-64-bit.exe
echo(
echo      Opcao 2 — uma linha, se voce tem Windows 10 ou 11:
echo        winget install --id Git.Git -e --source winget
echo(
echo      Depois de instalar, feche esta janela e rode este arquivo de novo.
echo(
goto fim

:cancelado
echo(
echo  Cancelado. Nada foi alterado.
echo(

:fim
echo(
pause
endlocal
