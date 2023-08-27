work_folder=/home/hdoop/R/src/prj
hdfs dfs -rm -r /prj/j2
hdfs dfs -mkdir /prj/j2
hdfs dfs -copyFromLocal $work_folder/Ordini.csv /prj/j2

cd $work_folder
chmod 777 $work_folder/j2/mapper.r $work_folder/j2/reducer.r 

hadoop jar /home/hdoop/Documents/hadoop-streaming-3.2.1.jar \
-file /home/hdoop/R/src/prj/j2/mapper.r  -mapper 'Rscript /home/hdoop/R/src/prj/j2/mapper.r' \
-file /home/hdoop/R/src/prj/j2/reducer.r -reducer 'Rscript /home/hdoop/R/src/prj/j2/reducer.r' \
-input /prj/j2/Ordini.csv -output /prj/j2/output 

hdfs dfs -cat /prj/j2/output/part-00000
