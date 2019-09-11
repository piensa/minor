let
   pkgs = import <nixpkgs> {};
   piensa = import (builtins.fetchTarball {
      url = https://github.com/piensa/nur-packages/archive/3866b8b.tar.gz;
      sha256="10ynr4988b8153j0pb6fxjwc00x165dc0lrhyx9h4w59p83rcv2d";
    }) {};
in let
   caddy = piensa.caddy;
   pytz = pkgs.python37Packages.pytz;
   sqlparse = pkgs.python37Packages.sqlparse;
   autobahn = pkgs.python37Packages.autobahn;
   twisted = pkgs.python37Packages.twisted;
   service-identity = pkgs.python37Packages.service-identity;
   asgiref = pkgs.python37Packages.asgiref.overrideAttrs (old: rec {
     name = "asgiref_${version}";
     version = "3.2.2";
     src = pkgs.fetchFromGitHub {
       owner = "django";
       repo = "asgiref";
       rev = version;
       sha256 = "11lnynspgdi5zp3hd8piy8h9fq0s3ck6lzyl7h0fn2mxxyx83yh2";
     };
   });
in let
   daphne = pkgs.python37Packages.daphne.overrideAttrs (old: rec {
     name = "daphne_2.3_${version}";
     version = "333f464";
     propagatedBuildInputs = [ asgiref autobahn twisted service-identity twisted.extras.tls];
     src = pkgs.fetchFromGitHub {
       owner = "django";
       repo = "daphne";
       rev = version;
       sha256 = "0q75nr595n17cqg22iv87hqy6ln8c85csmw0jjrqh9fbc0a15qcc";
     };
   });
   django = pkgs.python37Packages.django_2_2.overrideAttrs (old: rec {
      name = "django_${version}";
      version = "3.0a1";
      doCheck = true;
      propagatedBuildInputs = [ pytz sqlparse asgiref ];
      src = pkgs.fetchFromGitHub {
        owner = "Django";
        repo = "django";
        rev = version;
        sha256 = "0ikphn1a2mhr4z7r939makkvybp1sczc7wiphy5qa2385jrfcz78";
      };
   });
   caddyfile = pkgs.writeText "Caddyfile" ''
    0.0.0.0:2015

    header / {
      Referrer-Policy "same-origin"
      X-XSS-Protection "1; mode=block"
      X-Content-Type-Options "nosniff"
      X-Frame-Options "DENY"
      -Server
    }

    limits 750000000
    log / stdout "{combined}"
    errors stdout
   '';
in pkgs.dockerTools.buildLayeredImage {
  name = "piensa/swing";
  created = "now";
  contents = [ caddy daphne django piensa.tippecanoe pkgs.gdal pkgs.coreutils ];
  config.Entrypoint = [ "${pkgs.caddy}/bin/caddy" ];
  config.Cmd = [ "-conf" "${caddyfile}" ];
  maxLayers = 50;
}
