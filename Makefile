DIR = dir/
MAL_DIR = malicious_dir/
INTERVAL = 5


run: prepare
	 ./antivirusd.sh $(DIR) $(MAL_DIR) $(INTERVAL) &
restore: prepare
	 ./restore.sh $(DIR) $(MAL_DIR)
prepare:
	 mkdir -p $(MAL_DIR)
	 touch whitelist.txt
