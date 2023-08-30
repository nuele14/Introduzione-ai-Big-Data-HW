
work_folder=$PWD

rm -f performance.txt
hdfs dfs -rm -r /homework
hdfs dfs -mkdir /homework

time ./cmd1.sh 1>> performance.txt

time ./cmd2.sh 1>> performance.txt

time ./cmd3.sh 1>> performance.txt

time ./cmd4.sh 1>> performance.txt
