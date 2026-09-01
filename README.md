# dachshund-error-pages

HTTP error pages with dachshunds, for nginx, Apache httpd and Caddy.

Every page is one self-contained HTML file: inline CSS, inline SVG, a small
CSS animation, no external requests. Pages honour `prefers-reduced-motion`.

**Preview:** https://sitnikov.github.io/dachshund-error-pages/

## Pages

`pages/400.html` `401` `403` `404` `410` `429` `500` `502` `503` `504`

## Usage

Copy `pages/` somewhere the server can read, e.g. `/var/www/dachshund-error-pages/pages`.

### nginx

```nginx
error_page 400 /_errors/400.html;
error_page 401 /_errors/401.html;
error_page 403 /_errors/403.html;
error_page 404 /_errors/404.html;
error_page 410 /_errors/410.html;
error_page 429 /_errors/429.html;
error_page 500 /_errors/500.html;
error_page 502 /_errors/502.html;
error_page 503 /_errors/503.html;
error_page 504 /_errors/504.html;

location ^~ /_errors/ {
    alias /var/www/dachshund-error-pages/pages/;
    internal;
}
```

### Apache httpd

```apache
Alias "/_errors/" "/var/www/dachshund-error-pages/pages/"
<Directory "/var/www/dachshund-error-pages/pages">
    Require all granted
</Directory>
ErrorDocument 404 /_errors/404.html
# ... one ErrorDocument line per code
```

### Caddy

```caddy
handle_errors 400 401 403 404 410 429 500 502 503 504 {
    root * /var/www/dachshund-error-pages/pages
    rewrite * /{err.status_code}.html
    file_server
}
```

The preview site generates these snippets for whatever pages exist and has a copy button.

## Preview site

`scripts/build.sh` assembles `_site/` from `pages/` and `preview/index.html`
and writes `manifest.json` (code and headline of every page). GitHub Actions
runs it on every push to `main` and deploys the result to GitHub Pages.

Locally:

```sh
scripts/build.sh
python3 -m http.server 8000 -d _site
```
