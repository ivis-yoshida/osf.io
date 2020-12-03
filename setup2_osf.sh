#!/bin/bash

echo "ネットワーク設定"
sudo ifconfig lo:0 192.168.168.167 netmask 255.255.255.255 up

echo "ソースコード取得"
cd ~/
git clone https://github.com/CenterForOpenScience/osf.io.git
cd osf.io/

echo "設定ファイル置き換え"
mv ./admin/base/settings/local-dist.py ./admin/base/settings/local.py
mv ./tasks/local-dist.py ./tasks/local.py
mv ./website/settings/local-dist.py ./website/settings/local.py
mv ./addons/mendeley/settings/local-dist.py ./addons/mendeley/settings/local.py
mv ./addons/nextcloud/settings/local-dist.py ./addons/nextcloud/settings/local.py
mv ./addons/zotero/settings/local-dist.py ./addons/zotero/settings/local.py
mv ./addons/iqbrims/settings/local-dist.py ./addons/iqbrims/settings/local.py
mv ./addons/onedrive/settings/local-dist.py ./addons/onedrive/settings/local.py
mv ./addons/googledrive/settings/local-dist.py ./addons/googledrive/settings/local.py
mv ./addons/bitbucket/settings/local-dist.py ./addons/bitbucket/settings/local.py
mv ./addons/dropbox/settings/local-dist.py ./addons/dropbox/settings/local.py
mv ./addons/box/settings/local-dist.py ./addons/box/settings/local.py
mv ./addons/figshare/settings/local-dist.py ./addons/figshare/settings/local.py
mv ./addons/dropboxbusiness/settings/local-dist.py ./addons/dropboxbusiness/settings/local.py
mv ./addons/nextcloudinstitutions/settings/local-dist.py ./addons/nextcloudinstitutions/settings/local.py
mv ./addons/owncloud/settings/local-dist.py ./addons/owncloud/settings/local.py
mv ./addons/forward/settings/local-dist.py ./addons/forward/settings/local.py
mv ./addons/dataverse/settings/local-dist.py ./addons/dataverse/settings/local.py
mv ./api/base/settings/local-dist.py ./api/base/settings/local.py
mv ./docker-compose-dist.override.yml ./docker-compose.override.yml

echo "コンテナ起動"
docker-compose up requirements mfr_requirements wb_requirements
docker-compose up -d elasticsearch postgres mongo rabbitmq
rm -Rf ./node_modules
docker-compose up -d assets
docker-compose up -d admin_assets
docker-compose up -d mfr wb fakecas sharejs
docker-compose up -d worker web api admin preprints registries ember_osf_web
docker-compose run --rm web python3 manage.py migrate
docker-compose run --rm web python3 -m scripts.populate_institutions -e test -a
docker-compose run --rm web python3 manage.py populate_fake_providers
docker-compose run --rm web python3 -m scripts.parse_citation_styles
docker-compose run --rm web python3 -m scripts.register_oauth_scopes
docker-compose up -d ember_osf_web

