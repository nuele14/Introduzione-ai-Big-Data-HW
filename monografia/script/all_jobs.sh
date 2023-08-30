#!/bin/bash
export HADOOP_OPTS=-Djava.library.path=/usr/local/hadoop/lib/native
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CMD=/usr/local/hadoop/bin/hadoop
export HADOOP_STREAMING=/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.5.jar
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
work_folder=$PWD
cd $HADOOP_HOME/sbin
start-dfs.sh
start-yarn.sh

cd work_folder
rm -f performance.txt
hdfs dfs -rm -r /homework
hdfs dfs -mkdir /homework

# Job1
hdfs dfs -rm -r /homework/job1
hdfs dfs -mkdir /homework/job1
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job1
rm -f medie_calcolate
echo "Job1 - Somme iniziato"
start_time=$(date +%s)
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job1.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job1.r' -input /homework/job1/Ordini.csv -output /homework/job1/output
end_time=$(date +%s)
hdfs dfs -cat /homework/job1/output/part-00000
hdfs dfs -copyToLocal /homework/job1/output/part-00000 ./
elapsed_time=$((end_time - start_time))
echo "Job1 : ${elapsed_time} seconds" >> performance.txt
mv ./part-00000 ./medie_calcolate
hdfs dfs -mv /homework/job1/output/part-00000 /homework/job1/output/medie_calcolate

# Job2
hdfs dfs -rm -r /homework/job2
hdfs dfs -mkdir /homework/job2
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job2
rm -f varianze
echo "Job2 - Varianze iniziato"
start_time=$(date +%s)
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job2.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job2.r' -input /homework/job2/Ordini.csv -output /homework/job2/output
end_time=$(date +%s)
hdfs dfs -cat /homework/job2/output/part-00000
hdfs dfs -copyToLocal /homework/job2/output/part-00000 ./
elapsed_time=$((end_time - start_time))
echo "Job2 : ${elapsed_time} seconds" >> performance.txt
mv ./part-00000 ./varianze
hdfs dfs -mv /homework/job2/output/part-00000 /homework/job2/output/varianze

# Job3
hdfs dfs -rm -r /homework/job3
hdfs dfs -mkdir /homework/job3
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job3
rm -f max.txt
echo "Job 3 - Miglior mese per anno"
start_time=$(date +%s)
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job3.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job3.r' -input /homework/job3/Ordini.csv -output /homework/job3/output
end_time=$(date +%s)
hdfs dfs -cat /homework/job3/output/part-00000
hdfs dfs -copyToLocal /homework/job3/output/part-00000 ./
elapsed_time=$((end_time - start_time))
echo "Job3: ${elapsed_time} seconds" >> performance.txt
mv ./part-00000 ./max.txt
hdfs dfs -mv /homework/job3/output/part-00000 /homework/job3/output/max

# Job4
hdfs dfs -rm -r /homework/job4
hdfs dfs -mkdir /homework/job4
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /homework/job4
rm -f min.txt
echo "Job 4 - Peggior mese per anno"
start_time=$(date +%s)
hadoop jar $HADOOP_STREAMING -files $work_folder/mapper_job1.r,$work_folder/reducer_job4.r -mapper 'Rscript mapper_job1.r' -reducer 'Rscript reducer_job4.r' -input /homework/job4/Ordini.csv -output /homework/job4/output
end_time=$(date +%s)
hdfs dfs -cat /homework/job4/output/part-00000
hdfs dfs -copyToLocal /homework/job4/output/part-00000 ./
elapsed_time=$((end_time - start_time))
echo "Job4 : ${elapsed_time} seconds" >> performance.txt
mv ./part-00000 ./min.txt
hdfs dfs -mv /homework/job4/output/part-00000 /homework/job4/output/min

cd $HADOOP_HOME/sbin
stop-all.sh