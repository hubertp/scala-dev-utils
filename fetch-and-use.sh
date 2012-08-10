#!/bin/bash

main_repo=http://scalabuilds.typesafe.com/
cache_dir=~/.scala-builds

check-curl() {
	curl --version &> /dev/null
	if [ $? -ne 0 ]
	then
	  echo ""
	  echo "Please install curl to download the jar files."
	  echo ""
	  exit 1
	fi
}

get-scala-rev() {
	check-curl

	#needs to be full hash atm
	rev=$1
	url="$main_repo/$rev/pack.tgz"
	to_dir="$cache_dir/$rev"
	to_tarball="$to_dir/unpackme.tgz"
	if [ -e "$to_dir/pack/bin/scala" ]
	then
	  echo "Scala build $rev already exists at $to_dir"
	else
	  echo "Fetching Scala rev: $rev"
	  mkdir -p $cache_dir
	  mkdir -p $to_dir
	  to_tarball="$to_dir/unpackme.tgz"
	  http_code=$(curl --write-out '%{http_code}' --silent --fail --output "$to_tarball" "$url")
	  if [ $? != 0 ]
	  then
	    echo "Error downloading $rev: response code: $http_code"
	    echo "Used: $url"
	    exit 1
	  fi
	  tar zxvf $to_tarball -C "$to_dir/"
	  rm $to_tarball
	fi
}

set-scala-rev() {
	rev=$1
	export PATH="$cache_dir/$rev/pack/bin:$PATH"
}

get-and-set-scala-rev() {
	get-scala-rev $1
	set-scala-rev $1
}

