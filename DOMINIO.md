# Ligar o domínio mathiascasalaspro.com ao site

Domínio registrado no **GoDaddy**. Site publicado no **GitHub Pages**, repositório
`mcasalaspro/mathias-site`.

**Endereço final:** `https://www.mathiascasalaspro.com`
**Tempo:** 10 minutos de trabalho, mais 15 a 60 minutos de espera.

---

## Passo 1 — Publicar o arquivo CNAME

O projeto traz um arquivo chamado **`CNAME`** com uma única linha:

```
www.mathiascasalaspro.com
```

É ele que diz ao GitHub por qual endereço o site deve responder. Sem esse arquivo, qualquer
domínio apontado para o GitHub recebe uma página 404.

Dê dois cliques em **PUBLICAR.bat**.

---

## Passo 2 — Cadastrar o domínio no GitHub

1. Abra o repositório no GitHub
2. **Settings → Pages**
3. Em *Custom domain*, deve aparecer `www.mathiascasalaspro.com`. Se estiver vazio, digite e
   clique em **Save**

Vai surgir um aviso de que o DNS não está configurado — é esperado, o próximo passo resolve.

> Faça este passo **antes** de mexer no GoDaddy: é o que impede outra pessoa de reivindicar o
> endereço enquanto ele ainda não aponta para lugar nenhum.

---

## Passo 3 — Abrir o DNS no GoDaddy

1. Entre em `godaddy.com` → **Meus Produtos**
2. Encontre `mathiascasalaspro.com` e clique em **DNS**
3. Você cai na tela **Registros**

---

## Passo 4 — Apagar os registros de estacionamento

Todo domínio novo vem com registros que mostram a página "este domínio está registrado no
GoDaddy". Se ficarem, continuam vencendo.

**Apague estes dois:**

| Tipo | Nome | Como reconhecer |
|---|---|---|
| A | `@` | o valor é um IP começando com `76.`, `50.` ou `184.` |
| CNAME | `www` | o valor aponta para o próprio domínio ou para algo do GoDaddy |

**Não apague** o CNAME chamado `_domainconnect` nem os registros do tipo **NS**.

---

## Passo 5 — Criar os registros do GitHub

Clique em **Adicionar** e crie cinco registros.

**Quatro do tipo A**, todos com o mesmo nome `@`:

| Tipo | Nome | Valor | TTL |
|---|---|---|---|
| A | `@` | `185.199.108.153` | 600 segundos |
| A | `@` | `185.199.109.153` | 600 segundos |
| A | `@` | `185.199.110.153` | 600 segundos |
| A | `@` | `185.199.111.153` | 600 segundos |

São quatro entradas separadas com o mesmo nome. São os quatro servidores do GitHub: ter os
quatro garante que o site continue no ar se um deles cair.

**Um do tipo CNAME:**

| Tipo | Nome | Valor | TTL |
|---|---|---|---|
| CNAME | `www` | `mcasalaspro.github.io` | 600 segundos |

Se o GoDaddy reclamar do valor, tente com ponto no fim: `mcasalaspro.github.io.`

**Sobre o TTL:** 600 segundos são 10 minutos. Se errar algo, a correção aparece em 10 minutos
em vez de uma hora. Depois que tudo estiver certo, pode voltar para 1 hora.

---

## Passo 6 — Desativar o Encaminhamento

Este passo é fácil de esquecer e derruba tudo.

Volte em **Meus Produtos → mathiascasalaspro.com** e procure **Encaminhamento de domínio**
(*Domain Forwarding*). Se estiver ativo, **desative**.

O encaminhamento recria os registros de estacionamento por conta própria e desfaz o que você
acabou de configurar. É a causa mais comum de "fiz tudo certo e continua aparecendo a página
do GoDaddy".

---

## Passo 7 — Conferir

Espere uns 15 minutos. No Prompt de Comando:

```
nslookup mathiascasalaspro.com
nslookup www.mathiascasalaspro.com
```

| Comando | Resposta esperada |
|---|---|
| `mathiascasalaspro.com` | os quatro endereços de `185.199.108.153` a `185.199.111.153` |
| `www.mathiascasalaspro.com` | `mcasalaspro.github.io` |

Se ainda vier o endereço antigo, espere mais. Dá para acompanhar de vários países em
`dnschecker.org`.

---

## Passo 8 — Ligar o HTTPS

Volte em **Settings → Pages**. O aviso amarelo vira uma confirmação verde.

Espere a caixa **Enforce HTTPS** ficar clicável — o GitHub emite o certificado sozinho, o que
leva de alguns minutos a algumas horas — e então **marque**.

> Se depois de um dia a caixa continuar cinza: apague o domínio do campo *Custom domain*,
> salve, espere um minuto, digite de novo e salve. Isso força a emissão do certificado.

---

## Passo 9 — Testar

- [ ] `https://www.mathiascasalaspro.com` abre o site
- [ ] `https://mathiascasalaspro.com` (sem www) redireciona para o www
- [ ] o cadeado aparece, sem aviso de segurança
- [ ] o site abre no celular, em 4G, fora do seu Wi-Fi
- [ ] as três bandeiras de idioma funcionam
- [ ] as fotos e os vídeos carregam

Depois, atualize o endereço no Instagram, na assinatura de e-mail e onde mais o site estiver
divulgado.

---

## Se algo der errado

| Sintoma | Causa | Solução |
|---|---|---|
| Aparece a página de estacionamento do GoDaddy | Registros antigos ainda existem, ou o Encaminhamento está ativo | Passos 4 e 6 |
| Página 404 do GitHub | O arquivo `CNAME` não bate com o domínio | Confira que tem exatamente `www.mathiascasalaspro.com` e rode o PUBLICAR.bat |
| `www` funciona, domínio raiz não | Faltam os quatro registros A no `@` | Passo 5 |
| Domínio raiz funciona, `www` não | Falta o CNAME do `www` | Passo 5 |
| "Domain does not resolve to the GitHub Pages server" | DNS ainda não propagou, ou sobrou registro A antigo | Espere; confira o passo 4 |
| *Enforce HTTPS* fica cinza | Certificado ainda não emitido | Espere; use o truque do passo 8 |
| "Domain is already taken" | O domínio está configurado em outro repositório seu | Remova de lá primeiro |

Nada aqui é irreversível: para voltar atrás, basta apagar os cinco registros novos.
