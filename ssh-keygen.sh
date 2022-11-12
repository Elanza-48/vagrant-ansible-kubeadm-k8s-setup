#! /usr/bin/bash

MASTER_COUNT=1
WORKER_COUNT=2

ssh_directory=".vagrant/credentials/ssh"
ssh_key_name="ssh-key"

rm -rf $ssh_directory

# master nodes key-gen
for i in  $(seq 1 $MASTER_COUNT)
do
  mkdir -p "${ssh_directory}/master-${i}"
  ssh-keygen -qt ed25519 -C "elanza48@outlook.com" -N "" -o -f "${ssh_directory}/master-${i}/${ssh_key_name}"
  chmod 644 "${ssh_directory}/master-${i}/${ssh_key_name}.pub"
  chmod 600 "${ssh_directory}/master-${i}/${ssh_key_name}"
done

# worker nodes key-gen
for i in  $(seq 1 $WORKER_COUNT)
do
  mkdir -p "${ssh_directory}/worker-${i}"
  ssh-keygen -qt ed25519 -C "elanza48@outlook.com" -N "" -o -f "${ssh_directory}/worker-${i}/${ssh_key_name}"
  chmod 644 "${ssh_directory}/worker-${i}/${ssh_key_name}.pub"
  chmod 600 "${ssh_directory}/worker-${i}/${ssh_key_name}"
done
