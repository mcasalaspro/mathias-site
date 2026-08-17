# Point mathiascasalaspro.com to the GitHub Pages site

Domain registered at **GoDaddy**. Site hosted on **GitHub Pages**, repository
`mcasalaspro/mathias-site`.

**Final address:** `https://www.mathiascasalaspro.com`
**Time:** about 10 minutes of work, plus 15–60 minutes of waiting.

---

## Your current DNS records

This is what GoDaddy shows today, and what happens to each one:

| Type | Name | Data | Action |
|---|---|---|---|
| A | `@` | WebsiteBuilder Site | **Delete** — replaced by the four GitHub records |
| CNAME | `www` | `mathiascasalaspro.com.` | **Edit** — will point to GitHub instead |
| NS | `@` | `ns45.domaincontrol.com.` | Leave it (locked by GoDaddy) |
| NS | `@` | `ns46.domaincontrol.com.` | Leave it (locked by GoDaddy) |
| SOA | `@` | `ns45.domaincontrol.com.` | Leave it (locked by GoDaddy) |
| CNAME | `_domainconnect` | `_domainconnect.gd.domaincontrol.com.` | Leave it — harmless |
| TXT | `_dmarc` | `v=DMARC1; p=quarantine; ...` | Leave it — email policy, does not affect the website |

Only **two** records change. Everything else stays exactly as it is.

---

## Step 1 — Disconnect the GoDaddy Website Builder

Your `A` record says **"WebsiteBuilder Site"** instead of an IP address. That means a GoDaddy
Website Builder site is attached to this domain.

**This matters:** if the Website Builder stays connected, GoDaddy may restore that `A` record
automatically and undo your work.

1. Go to **My Products**
2. Find the **Website Builder** (or *Websites + Marketing*) entry
3. Open **Settings → Domain** (labels vary slightly)
4. **Disconnect** the domain `mathiascasalaspro.com` from it

If you cannot find it, skip to Step 3 anyway. GoDaddy will show a warning when you delete the
`A` record — accept it. If the record reappears within a few hours, come back to this step.

---

## Step 2 — Add the domain in GitHub

Do this **before** touching DNS. It prevents anyone else from claiming the address while it is
not yet pointed anywhere.

The project already contains a file named **`CNAME`** with a single line:

```
www.mathiascasalaspro.com
```

Double-click **PUBLICAR.bat** to upload it.

Then, in your repository on GitHub:

1. **Settings → Pages**
2. Under *Custom domain*, it should read `www.mathiascasalaspro.com`
3. If the field is empty, type it and click **Save**

You will see a warning saying the DNS is not configured. That is expected — Step 3 fixes it.

---

## Step 3 — Delete the two old records

In GoDaddy: **My Products → mathiascasalaspro.com → DNS**

Click the **trash icon** on these two rows:

| Type | Name | Data |
|---|---|---|
| A | `@` | WebsiteBuilder Site |
| CNAME | `www` | `mathiascasalaspro.com.` |

Do **not** delete the `NS`, `SOA`, `_domainconnect` or `_dmarc` records. The `NS` and `SOA`
rows show a lock icon anyway — GoDaddy does not allow it.

---

## Step 4 — Add the five new records

Click **Add New Record** and create these, one at a time.

**Four A records**, all with the same name `@`:

| Type | Name | Value | TTL |
|---|---|---|---|
| A | `@` | `185.199.108.153` | Custom → 600 seconds |
| A | `@` | `185.199.109.153` | Custom → 600 seconds |
| A | `@` | `185.199.110.153` | Custom → 600 seconds |
| A | `@` | `185.199.111.153` | Custom → 600 seconds |

Yes — four separate entries with the same name. These are GitHub's four servers; having all
four keeps the site online if one of them goes down.

**One CNAME record:**

| Type | Name | Value | TTL |
|---|---|---|---|
| CNAME | `www` | `mcasalaspro.github.io` | Custom → 600 seconds |

**About the TTL:** GoDaddy's dropdown offers *1 Hour* by default. Choose **Custom** and type
**600** seconds (10 minutes). If you make a mistake, the fix propagates in 10 minutes instead
of an hour. Once everything works, you can set it back to 1 Hour.

When you are done, the record list should look like this:

```
A       @                185.199.108.153
A       @                185.199.109.153
A       @                185.199.110.153
A       @                185.199.111.153
CNAME   www              mcasalaspro.github.io
CNAME   _domainconnect   _domainconnect.gd.domaincontrol.com.
NS      @                ns45.domaincontrol.com.
NS      @                ns46.domaincontrol.com.
SOA     @                ns45.domaincontrol.com.
TXT     _dmarc           v=DMARC1; p=quarantine; ...
```

---

## Step 5 — Turn off Domain Forwarding

Easy to miss, and it breaks everything.

Go back to **My Products → mathiascasalaspro.com** and look for **Forwarding** (sometimes under
*Domain Settings*). If any forwarding rule is active, **turn it off**.

Forwarding recreates the parking records on its own and undoes what you just configured. It is
the most common cause of "I set everything correctly and the GoDaddy page still shows up".

---

## Step 6 — Check that it worked

Wait about 15 minutes. Then, in Command Prompt:

```
nslookup mathiascasalaspro.com
nslookup www.mathiascasalaspro.com
```

| Command | Expected answer |
|---|---|
| `mathiascasalaspro.com` | the four addresses `185.199.108.153` through `185.199.111.153` |
| `www.mathiascasalaspro.com` | `mcasalaspro.github.io` |

If the old address still comes back, wait longer and try again. You can also watch it from
several countries at `dnschecker.org`.

---

## Step 7 — Enable HTTPS

Go back to **Settings → Pages** on GitHub. The yellow warning turns into a green confirmation.

Wait for the **Enforce HTTPS** checkbox to become clickable — GitHub issues the certificate on
its own, which takes anywhere from a few minutes to a few hours — then **tick it**.

> If it is still greyed out after a day: clear the *Custom domain* field, click Save, wait a
> minute, type it again and Save. That forces the certificate to be issued.

---

## Step 8 — Final checks

- [ ] `https://www.mathiascasalaspro.com` opens the site
- [ ] `https://mathiascasalaspro.com` (no www) redirects to the www address
- [ ] the padlock shows, with no security warning
- [ ] the site opens on a phone over 4G, outside your Wi-Fi
- [ ] the three language flags work
- [ ] photos and videos load

Then update the address on Instagram, in your email signature, and anywhere else the site is
listed.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| GoDaddy parking page still shows | Old records still there, or Forwarding is on | Steps 3 and 5 |
| The `A` record comes back by itself | Website Builder is still connected | Step 1 |
| GitHub 404 page | The `CNAME` file does not match the domain | Check it reads exactly `www.mathiascasalaspro.com`, then run PUBLICAR.bat |
| `www` works, root domain does not | The four `A` records are missing | Step 4 |
| Root domain works, `www` does not | The `www` CNAME is missing | Step 4 |
| "Domain does not resolve to the GitHub Pages server" | DNS has not propagated, or an old `A` record remains | Wait; check Step 3 |
| *Enforce HTTPS* stays greyed out | Certificate not issued yet | Wait; use the trick in Step 7 |
| "Domain is already taken" | The domain is configured in another repository of yours | Remove it there first |

Nothing here is irreversible. To undo, delete the five new records and put the old ones back.
