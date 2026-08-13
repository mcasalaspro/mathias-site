@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
title Atualizar views e curtidas

echo(
echo  ============================================
echo    ATUALIZAR VIEWS E CURTIDAS
echo  ============================================
echo(
echo  Consulta o YouTube, soma tudo e grava em dados/alcance.json.
echo  Depois e so rodar o PUBLICAR.bat para o site mostrar os numeros.
echo(

rem ---------- Python instalado? ----------
set "PY="
py -3 --version >nul 2>&1 && set "PY=py -3"
if not defined PY (
  python --version >nul 2>&1 && set "PY=python"
)
if not defined PY goto sem_python

rem ---------- chave ----------
if defined YOUTUBE_API_KEY goto tem_chave
if exist "ferramentas\chave.txt" goto le_arquivo

echo  Cole a sua chave da YouTube Data API v3.
echo(
echo  A chave NAO pode estar restrita por "Referenciadores HTTP" — este script
echo  roda no seu computador e nao envia referenciador. No Google Cloud, deixe
echo  "Restricoes de aplicativo" em "Nenhuma" e mantenha a restricao de API.
echo(
set /p "CHAVE=   Chave: "
if "!CHAVE!"=="" goto cancelado
set "YOUTUBE_API_KEY=!CHAVE!"
echo(
set "SALVAR="
set /p "SALVAR=   Guardar a chave para nao pedir de novo? (s/N): "
if /i "!SALVAR!"=="s" (
  echo !CHAVE!> "ferramentas\chave.txt"
  echo   Guardada em ferramentas\chave.txt — esse arquivo nao vai para o GitHub.
)
goto rodar

:le_arquivo
set /p YOUTUBE_API_KEY=<ferramentas\chave.txt
echo  Usando a chave guardada em ferramentas\chave.txt
goto rodar

:tem_chave
echo  Usando a chave da variavel de ambiente YOUTUBE_API_KEY

:rodar
echo(
%PY% ferramentas\atualizar-alcance.py
if errorlevel 1 goto erro
echo(
echo  ============================================
echo    PRONTO. Agora rode o PUBLICAR.bat.
echo  ============================================
echo(
goto fim

:erro
echo(
echo  [!] Nao deu certo. A mensagem acima diz o motivo.
echo(
echo      Se aparecer "ERRO HTTP 403", a chave esta restrita por referenciador.
echo      Abra a chave no Google Cloud e mude "Restricoes de aplicativo"
echo      para "Nenhuma", mantendo a restricao da YouTube Data API v3.
echo(
echo      Se aparecer "ERRO HTTP 400", a chave esta errada ou incompleta.
echo      Apague ferramentas\chave.txt e rode de novo para colar outra.
echo(
goto fim

:sem_python
echo  [!] Nao encontrei o Python neste computador.
echo(
echo      Baixe em https://www.python.org/downloads/
echo      Na primeira tela, marque "Add python.exe to PATH".
echo(
echo      Alternativa sem instalar nada: configure a GitHub Action.
echo      O passo a passo esta no LEIA-ME.md, secao 3.
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
