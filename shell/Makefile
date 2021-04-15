help:           ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	
common: 
	@sh -x script/common.sh

frontend:	common          #Install frontend web components
	@sh script/frontend.sh

