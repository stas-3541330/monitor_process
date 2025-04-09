NAME=monitor_process
BIN_DIR = /usr/local/bin
SERVICE_DIR = /etc/systemd/system
CONF_DIR = /etc/$(NAME)

SERVICE_FILES = $(wildcard *.service)
SCRIPT_FILES = $(wildcard *.sh)
CONF_FILES = $(wildcard *.conf)
TIMER_FILES = $(wildcard *.timer)


all: start

install: create_directories copy_files
clear: delete_scripts stop

create_directories:	
	@echo "Checking directories..."
	@if [ ! -d $(CONF_DIR) ]; then \
		echo "Directory $(CONF_DIR) does not exist. Creating..."; \
		mkdir -p $(CONF_DIR) && echo "Directory $(CONF_DIR) created."; \
	else \
		echo "Directory $(CONF_DIR) already exists."; \
	fi

copy_files:
	@echo "Copying files..."
	cp $(SCRIPT_FILES) $(BIN_DIR)
	cp $(SERVICE_FILES) $(SERVICE_DIR)
	cp $(TIMER_FILES) $(SERVICE_DIR)
	cp $(CONF_FILES) $(CONF_DIR)

start:
	echo "Enabling and starting the systemd service..."
	systemctl daemon-reload
	$(foreach timer,$(TIMER_FILES), \
		systemctl enable $(timer) && systemctl start $(timer) \
	) 

stop:
	@echo "Stop services"
	$(foreach timer, $(TIMER_FILES), \
		systemctl stop $(timer) && systemctl disable $(timer) \
	)
	systemctl daemon-reload


delete_scripts:
	@echo "Delete scripts"
	$(foreach script,$(SCRIPT_FILES), rm -f $(BIN_DIR)/$(script))
	$(foreach service,$(SERVICE_FILES), rm -f $(SERVICE_DIR)/$(service))
	$(foreach conf,$(CONF_FILES), rm -f $(CONF_DIR)/$(conf))
	$(foreach timer, $(TIMER_FILES), rm -f $(SERVICE_DIR)/$(timer))


.PHONY: all install create_directories copy_files start stop clear delete_scripts

