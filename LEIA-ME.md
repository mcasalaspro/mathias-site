# Site do Mathias — como publicar e manter

HTML puro. Sem WordPress, sem framework, sem build. Publicado no **GitHub Pages**, no
repositório `mcasalaspro/mathias-site`, no domínio **www.mathiascasalaspro.com**.

**Você não precisa abrir o `index.html` para atualizar o site.** Tudo que muda está em `dados/`.

```
CNAME                         o domínio do site
DOMAIN-SETUP.md               passo a passo do GoDaddy (em inglês, como os painéis)
PUBLICAR.bat                  envia tudo para o GitHub
CONFIGURAR-GIT.bat            prepara o Git na máquina (uma vez só)
ATUALIZAR-ALCANCE.bat         soma views e curtidas dos vídeos
VER-LOCAL.bat                 abre o site na sua máquina para conferir

index.html                    o site (não precisa ser editado)
dados/conteudo.json           números, conquistas, imprensa, contato
dados/videos.json             lista de vídeos do YouTube
dados/galeria.json            legendas das fotos
dados/hero.json               legendas das imagens do topo
dados/alcance.json            views e curtidas (gerado pelo script)
dados/idiomas/                traduções: pt.json, en.json, it.json

assets/hero/                  imagens de fundo da primeira dobra
assets/galeria/               fotos da tira de momentos
assets/loja/                  fotos dos produtos
ferramentas/                  o script que consulta o YouTube
.github/workflows/            rotinas que rodam sozinhas no GitHub
```

---

## 1. Publicar uma alteração

Edite o que quiser e dê dois cliques em **PUBLICAR.bat**. Descreva a mudança ou só tecle Enter.
O site no ar se atualiza em cerca de um minuto.

Se nada tiver mudado, o script avisa e não faz nada.

## 2. Ver na sua máquina antes de publicar

Dois cliques em **VER-LOCAL.bat**. Ele sobe um servidor e abre o navegador em
`http://localhost:8000`.

Abrir o `index.html` com dois cliques mostra o site pela metade: o navegador não deixa uma
página em `file://` ler os arquivos de dados. O site não quebra — cai nas cópias de reserva
que estão dentro do próprio HTML —, mas o que você vê pode não refletir suas edições.

---

## 3. O que fica em cada arquivo

### `dados/conteudo.json`

| Bloco | O que controla |
|---|---|
| `numeros` | Os cinco números da faixa azul |
| `caminho` | Rating, normas, meta mensal e a régua |
| `conquistas` | A linha do tempo, agrupada por ano |
| `imprensa` | As matérias, agrupadas por assunto |
| `custeio` | A lista "o que uma temporada exige" |
| `apoios` | Os quatro valores de contribuição mensal |
| `loja` | Os produtos de "apoiar levando algo em troca" |
| `contato` | WhatsApp, e-mail e Instagram |
| `anoNascimento` | Calcula a idade em cada ano da linha do tempo |

**A meta é mensal.** `metaMensal` é quanto se pretende arrecadar por mês; `apoioMensal` é
quanto já está garantido. A barra e a calculadora saem daí — não há nada a calcular.

**A régua de rating** usa `escala` e `marcos`. A barra dourada enche até `ratingAtual`.

### `dados/videos.json`

Cole a URL do YouTube e pronto — aceita `watch?v=`, `youtu.be/`, `/shorts/` e `/embed/`. O
primeiro da lista aparece grande no mosaico. Não precisam ser do canal dele: qualquer vídeo
público entra.

### `dados/galeria.json` e `dados/hero.json`

São os arquivos das **legendas**. Cada foto tem `destaque` (o trecho dourado), `legenda` e
`alt` (para leitores de tela). As rotinas do GitHub reescrevem esses arquivos quando você
adiciona ou remove imagens, **mas sempre preservam os textos que você escreveu**.

Para acrescentar fotos, largue os arquivos em `assets/galeria/` ou `assets/hero/` e publique.
Use o padrão `AAAA-MM_evento_descricao.jpg`: a ordem da tira segue o nome, do mais recente
para o mais antigo.

Fotos grandes deixam o site lento. Redimensione para no máximo 1600px de largura, JPG
qualidade 80.

---

## 4. Views e curtidas

A seção **Alcance** mostra a soma exata das visualizações e curtidas de todos os vídeos da
lista, com a data da medição.

Para atualizar, dois cliques em **ATUALIZAR-ALCANCE.bat** e depois **PUBLICAR.bat**. O script
consulta o YouTube, soma tudo e grava em `dados/alcance.json`.

A chave da API fica em `ferramentas/chave.txt`, que está no `.gitignore` e **nunca vai para o
GitHub**. Se algum dia precisar recriá-la: no Google Cloud, ative a YouTube Data API v3, crie
uma chave de API, deixe *Restrições de aplicativo* em **Nenhuma** e marque só a YouTube Data
API v3 em *Restrições de API*.

Também dá para automatizar: guarde a chave em *Settings → Secrets and variables → Actions* com
o nome `YOUTUBE_API_KEY`, e a rotina roda toda madrugada sozinha.

**Se um vídeo tiver as curtidas escondidas**, ele entra como zero na soma. O total fica
subestimado, nunca inflado.

---

## 5. O que ainda vale preencher

- [ ] **Valores dos três planos de patrocínio** — estão como `R$ ___` no `index.html`. São os
      únicos textos que ainda pedem edição direta no HTML.
- [ ] **Confirmar o `anoNascimento`** (`2012`) em `dados/conteudo.json`. É ele que calcula
      todas as idades da linha do tempo de uma vez.
- [ ] **Confirmar os quatro selos "Destaque!"** das conquistas.
- [ ] **PDF do mídia kit** em `assets/midia-kit-mathias.pdf` — o botão já aponta para lá.
- [ ] **Trocar `assets/og-mathias.jpg`** pela versão definitiva. É a imagem que aparece quando
      alguém manda o link no WhatsApp.
- [ ] **Definir a meta mensal.** Os R$ 2.500 são uma estimativa, não um número seu.

---

## 6. Quatro decisões que valem explicar

**A página tem dois atos.** Do topo até vídeos e imprensa, é um site de atleta: sem botão de
doação, sem pedido no meio do texto. A faixa com o peão dourado marca a virada, e só então vem
o bloco de apoio. O visitante conhece a trajetória inteira antes de qualquer pedido.

**A idade não aparece em nenhum texto corrido.** Só as idades dos feitos ("aos 11 anos,
derrotou um GM"), que nunca desatualizam.

**As conquistas são uma lista seca, e isso é de propósito.** Antes dela vem um quadro
explicando GM, FM, rating e norma — porque quem assina patrocínio geralmente não joga xadrez.

**Os números de alcance são exatos, não arredondados.** Arredondado, parecia estimativa. O
dado é medido, e a data da medição aparece ao lado.

---

## 7. Detalhe técnico, para quem for mexer no código

O `index.html` traz o conteúdo escrito dentro dele. É a rede de segurança: se algum JSON
quebrar, ou se a página for aberta em `file://`, o site continua completo em vez de aparecer
vazio. Quando os JSON carregam — o que leva milésimos —, eles substituem esse conteúdo.

Consequência: o conteúdo dentro do HTML vai ficando velho conforme você edita os JSON. Isso
não afeta o que as pessoas veem, só o que um robô sem JavaScript leria. Google e Bing executam
JavaScript há anos.

Os JSON são buscados com um sufixo que muda a cada cinco minutos (`?v=...`), para que uma
edição apareça rápido mesmo com cache no caminho.
