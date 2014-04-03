#!/bin/bash


if [ ! -f $PWD/ProdTool/scripts/cronScript.sh ]; then
cp $PWD/ProdTool/scripts/cronScript_template.sh $PWD/ProdTool/scripts/cronScript.sh
sed -i "s|CMSSWEnvVar|$1|g" $PWD/ProdTool/scripts/cronScript.sh
chmod +rwx $PWD/ProdTool/scripts/cronScript.sh

cp $PWD/ProdTool/crontab_template.txt $PWD/ProdTool/crontab.txt
sed -i "s|CMSSWEnvVar|$2|g" $PWD/ProdTool/crontab.txt

chmod +rwx $PWD/ProdTool/scripts/cronScript.sh

fi
