mkdir -p headerDoc
echo 'argument:+'$1
find $1 -name \*.m  -print | xargs headerdoc2html -o headerDoc
echo 'argument2:+'$?
if [[ $? == 0 ]]; then
	export LC_COLLATE='C'
	export LC_CTYPE='C'
	grep -rl "&lt;apiXmpBegin&gt;" ./headerDoc | xargs sed -i '' 's/&lt;apiXmpBegin&gt;/<pre>/g'
	grep -rl "&lt;apiXmpEnd&gt;" ./headerDoc | xargs sed -i '' 's/&lt;apiXmpEnd&gt;/<\/pre> /g'
	perl gatherheaderdoc.pl -o headerDoc
	find ./headerDoc -name 'MasterTOC.html' | xargs perl -pi -e 's|<!DOCTYPE|<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE|g'
	exit 0
fi

