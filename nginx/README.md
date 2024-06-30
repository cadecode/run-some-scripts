# nginx

> A docker image for nginx bundled some plugins，such as http image filter module.

## Usage

Pull image

```shell
docker pull cadecode/nginx:1.21.3-bundled-image-filter
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
