#!/usr/bin/env python3
"""
Soma as visualizações e as curtidas de todos os vídeos de dados/videos.json
e grava o resultado em dados/alcance.json.

Roda em dois lugares:
  - na GitHub Action (.github/workflows/alcance.yml), toda madrugada;
  - na sua máquina, pelo ATUALIZAR-ALCANCE.bat.

A chave da API vem da variável de ambiente YOUTUBE_API_KEY.
Não usa nenhuma biblioteca externa.
"""

import json
import os
import re
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENTRADA = os.path.join(RAIZ, "dados", "videos.json")
SAIDA = os.path.join(RAIZ, "dados", "alcance.json")

PADRAO_ID = re.compile(r"(?:v=|youtu\.be/|/shorts/|/embed/|/live/)([A-Za-z0-9_-]{11})")


def id_do_youtube(valor):
    """Aceita watch?v=, youtu.be/, /shorts/, /embed/ ou o próprio id."""
    s = str(valor or "").strip()
    achou = PADRAO_ID.search(s)
    if achou:
        return achou.group(1)
    return s if re.fullmatch(r"[A-Za-z0-9_-]{11}", s) else None


def le_ids():
    with open(ENTRADA, encoding="utf-8") as f:
        dados = json.load(f)
    ids = []
    for item in dados.get("videos", []):
        bruto = item if isinstance(item, str) else (item.get("url") or item.get("id"))
        vid = id_do_youtube(bruto)
        if vid and vid not in ids:
            ids.append(vid)
    return ids


def consulta(ids, chave):
    """A API aceita até 50 ids por chamada."""
    itens = []
    for i in range(0, len(ids), 50):
        lote = ids[i:i + 50]
        url = (
            "https://www.googleapis.com/youtube/v3/videos"
            "?part=snippet,statistics&id=" + ",".join(lote) + "&key=" + chave
        )
        try:
            with urllib.request.urlopen(url, timeout=30) as r:
                itens += json.load(r).get("items", [])
        except urllib.error.HTTPError as e:
            corpo = e.read().decode("utf-8", "replace")
            motivo = ""
            try:
                motivo = json.loads(corpo)["error"]["message"]
            except Exception:
                motivo = corpo[:300]
            print(f"ERRO HTTP {e.code}: {motivo}", file=sys.stderr)
            if e.code == 403:
                print(
                    "\nCausa mais comum: a chave está restrita por 'Referenciadores HTTP'.\n"
                    "Uma chamada de servidor não envia referenciador, então ela é recusada.\n"
                    "No Google Cloud, abra a chave e deixe 'Restrições de aplicativo' em\n"
                    "'Nenhuma', mantendo a restrição de API na YouTube Data API v3.",
                    file=sys.stderr,
                )
            sys.exit(1)
        except Exception as e:  # rede fora do ar, DNS, timeout
            print(f"ERRO ao consultar a API: {e}", file=sys.stderr)
            sys.exit(1)
    return itens


def main():
    chave = os.environ.get("YOUTUBE_API_KEY", "").strip()
    if not chave:
        print(
            "Falta a chave. Defina YOUTUBE_API_KEY antes de rodar.\n"
            "  Windows:  set YOUTUBE_API_KEY=sua-chave\n"
            "  Linux/Mac: export YOUTUBE_API_KEY=sua-chave",
            file=sys.stderr,
        )
        sys.exit(1)

    ids = le_ids()
    if not ids:
        print("Nenhum vídeo válido em dados/videos.json.", file=sys.stderr)
        sys.exit(1)
    print(f"{len(ids)} vídeo(s) na lista.")

    itens = consulta(ids, chave)
    if not itens:
        print("A API não devolveu nenhum vídeo. IDs errados ou vídeos privados?", file=sys.stderr)
        sys.exit(1)

    views = curtidas = 0
    sem_curtidas = []
    por_video = {}
    for v in itens:
        st = v.get("statistics", {}) or {}
        nv = int(st.get("viewCount", 0) or 0)
        # likeCount some quando o dono do vídeo esconde as curtidas
        tem_like = "likeCount" in st
        nl = int(st.get("likeCount", 0) or 0)
        views += nv
        curtidas += nl
        if not tem_like:
            sem_curtidas.append(v["id"])
        por_video[v["id"]] = {
            "titulo": (v.get("snippet", {}) or {}).get("title", ""),
            "views": nv,
            "curtidas": nl if tem_like else None,
        }

    faltando = [i for i in ids if i not in por_video]

    saida = {
        "_leia": (
            "Gerado por ferramentas/atualizar-alcance.py. Não edite à mão: "
            "o arquivo é reescrito a cada atualização."
        ),
        "atualizadoEm": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "views": views,
        "curtidas": curtidas,
        "videos": len(por_video),
        "curtidasOcultasEm": len(sem_curtidas),
        "porVideo": por_video,
    }
    with open(SAIDA, "w", encoding="utf-8") as f:
        json.dump(saida, f, ensure_ascii=False, indent=2)
        f.write("\n")

    print(f"  visualizações: {views:,}".replace(",", "."))
    print(f"  curtidas:      {curtidas:,}".replace(",", "."))
    if sem_curtidas:
        print(f"  atenção: {len(sem_curtidas)} vídeo(s) com curtidas ocultas entram como zero.")
    if faltando:
        print(f"  atenção: {len(faltando)} id(s) não voltaram da API: {', '.join(faltando)}")
    print(f"\nGravado em dados/alcance.json")


if __name__ == "__main__":
    main()
