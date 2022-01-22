#! /bin/sh

if [ ! -d $HOME/opt ];
then
	mkdir $HOME/opt
fi

if [ -x $HOME/opt/moltemplate ]; then
	echo "OK! moltemplate was found"
else
	echo "* moving to $HOME/opt dir."
	cd  $HOME/opt
	echo "** installing moltemplate"
	git clone https://github.com/jewettaij/moltemplate moltemplate
	cd moltemplate
	if [ -x /usr/bin/pip ]; then
		pip install . --user
	elif [ -x /usr/bin/pip3 ]; then
		pip3 install . --user
	else
		echo "pip and pip3 not found"
	fi
fi
