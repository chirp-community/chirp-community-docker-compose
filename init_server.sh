#!/bin/bash
# ubuntu 기준.

# docker 설치
echo "================================"
echo "(docker install)[0/7]"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
echo "(docker install)[1/7]"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "(docker install)[2/7]"
sudo add-apt-repository -y \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
echo "(docker install)[3/7]"
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
echo "(docker install)[4/7]"
sudo systemctl enable docker
echo "(docker install)[5/7]"
sudo service docker start
echo "(docker install)[6/7]"
sudo usermod -a -G docker $USER
echo "(docker install)[7/7]"

# docker-compose 설치
echo "================================"
echo "(docker-compose install)[0/2]"
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
echo "(docker-compose install)[1/2]"
sudo chmod +x /usr/local/bin/docker-compose
echo "(docker-compose install)[2/2]"

# docker-compose.yml에 적용할 .env 파일 복사.
echo "================================"
echo "(mock.env를 이용해 .env 파일 생성)[0/1]"
cp mock.env .env
echo "cat .env"
cat .env
echo "(mock.env를 이용해 .env 파일 생성)[1/1]"

# 경로 생성 및 권한 부여
echo "================================"
echo "(경로 생성 및 권한 부여)[0/2]"
export $(grep -v '^#' .env | xargs)

function setPath {
        DIR=$1
        echo $DIR
        mkdir -p $DIR
        sudo chmod 777 $DIR
}
echo "(경로 생성 및 권한 부여)[1/2]"
setPath $DIR_MOUNTED_MYSQL
echo "(경로 생성 및 권한 부여)[2/2]"

# 완벽한 적용을 위한 서버 리부트
echo "================================"
echo "reboot"
sudo reboot
