# nginx

> A docker image for nginx bundled some plugins，such as http image filter module
>
> More about: https://github.com/cadecode/run-some-scripts/tree/main/nginx

## Usage

Pull image

```shell
docker pull cadecode/nginx:1.21.3-bundled-image-filter
```

Edit docker-compose.yml
```yaml
version: "3.8"

services:
  nginx:
    image: cadecode/nginx:1.21.3-bundled-image-filter
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /path/to/nginx.conf:/etc/nginx/nginx.conf
      - /path/to/html:/usr/share/nginx/html
```

Run compose

```shell
docker compose up -d
```

## Tag

### bundled-image-filter

Config image filter in `nginx.conf`

```
location ~ ^/(.*\.(jpg|jpeg|png|gif))!(.*)!(.*)$ {
  set $width  $3;
  set $height $4;
  image_filter resize $width $height;
  image_filter_buffer 100M;
  alias /usr/share/nginx/html/$1;
}
```

E.g., the url request for image, `http://.../a.jpg!500!400`, will get filtered size `500X400`. Also, `a.jpg!500!-` will get isometric scaling
