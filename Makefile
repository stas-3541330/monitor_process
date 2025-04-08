NAME=monitor_process
BIN_DIR = /usr/local/bin
SERVICE_DIR = /etc/systemd/system
CONF_DIR = /etc/$(NAME)
SERVICE_FILE = $(NAME).service
SCRIPT_FILE = $(NAME).sh
CONF_FILE = $(NAME).conf

all: start

install: create_directories copy_files


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
	cp $(SCRIPT_FILE) $(BIN_DIR)
	cp $(SERVICE_FILE) $(SERVICE_DIR)
	cp $(CONF_FILE) $(CONF_DIR)

start:
	echo "Enabling and starting the systemd service..."
	systemctl daemon-reload
	systemctl enable $(SERVICE_FILE)
	systemctl start $(SERVICE_FILE)

clear:
	@echo "Cleaning up files and services..."
	rm -f $(BIN_DIR)/$(SCRIPT_FILE)
	rm -f $(SERVICE_DIR)/$(SERVICE_FILE)
	rm -f $(CONF_DIR)/$(CONF_FILE)
	systemctl stop $(SERVICE_FILE)
	systemctl disable $(SERVICE_FILE)
	systemctl daemon-reload

.PHONY: all install create_directories copy_files start clear

