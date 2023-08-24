#!/bin/bash
# Autore: Marco La Ventura
# matricola: 627HHHINGINFOR
# shell di lancio programma contabilità
fileOrdini="/home/hadoop/Ordini.csv" HOME_PYTHON="/home/hadoop/prjpython" HOME_R="/home/hadoop/prjr" HOME_OUTPUT="/home/hadoop/output"
#controllo esistenza file
if [ ! -f "$fileOrdini" ]; then
    echo "file Ordini "$fileOrdini" non esiste"
    exit 1
fi
# cancella file se esistente su hadoop $HADOOP_HOME/bin/hdfs dfs -rm -R /tmp/Ordini.csv
# carico file Ordini su hdfs
$HADOOP_HOME/bin/hdfs dfs -copyFromLocal $fileOrdini /tmp/Ordini.csv
## cancella directory di outpur
rm -rf $HOME_OUTPUT
mkdir $HOME_OUTPUT
chmod 777 $HOME_OUTPUT
### Lancio programmi senza framework hadoop - python
python3 $HOME_PYTHON/prjmedia/media.py >> $HOME_OUTPUT/output_media_python.txt python3 $HOME_PYTHON/prjvarianza/varianza.py >> $HOME_OUTPUT/output_varianza_python.txt python3 $HOME_PYTHON/prjmaggvendita/mesemax.py >> $HOME_OUTPUT/output_valmagg_python.txt python3 $HOME_PYTHON/prjminvendita/mesemin.py >> $HOME_OUTPUT/output_valmin_python.txt ## Lancio programmi senza framework hadoop - R
Rscript $HOME_R/prjmedia/calcoloMedia.R >> $HOME_OUTPUT/output_media_R.txt Rscript $HOME_R/prjvarianza/calcoloVarianza.R >> $HOME_OUTPUT/output_varianza_R.txt Rscript $HOME_R/prjmaxr/maxvendita.R >> $HOME_OUTPUT/output_valmagg_R.txt Rscript $HOME_R/prjminr/minvendita.R >> $HOME_OUTPUT/output_valmin.txt
## Lancia programmi con HADOOP - PYTHON
$HADOOP_HOME/bin/hdfs dfs -rm -R /output/media-python
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/media-python -mapper "python3 $HOME_PYTHON/prjmedia/mapperMedia.py" -reducer "python3 $HOME_PYTHON/prjmedia/reducerMedia.py"
$HADOOP_HOME/bin/hdfs dfs -get /output/media-python/part-00000
$HOME_OUTPUT/output_MR_mediapy.txt

$HADOOP_HOME/bin/hdfs dfs -rm -R /output/varianza-python
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/varianza-python -mapper "python3 $HOME_PYTHON/prjvarianza/mapperVarianza.py" -reducer "python3 $HOME_PYTHON/prjvarianza/reducerVarianza.py"
$HADOOP_HOME/bin/hdfs dfs -get /output/varianza-python/part-00000
$HOME_OUTPUT/output_MR_varianzapy.txt

$HADOOP_HOME/bin/hdfs dfs -rm -R /output/min-python
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/min-python -mapper "python3 $HOME_PYTHON/prjminvendita/mapvend.py" -reducer "python3 $HOME_PYTHON/prjminvendita/redminvendita.py"
$HADOOP_HOME/bin/hdfs dfs -get /output/min-python/part-00000
$HOME_OUTPUT/output_MR_minpy.txt

$HADOOP_HOME/bin/hdfs dfs -rm -R /output/max-python
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/max-python -mapper "python3 $HOME_PYTHON/prjmaggvendita/mapmaxvend.py" -reducer "python3 $HOME_PYTHON/prjmaggvendita/redmaxvendita.py"
$HADOOP_HOME/bin/hdfs dfs -get /output/max-python/part-00000
$HOME_OUTPUT/output_MR_maxpy.txt
## Lancia programmi con HADOOP - R
$HADOOP_HOME/bin/hdfs dfs -rm -R /output/media-R
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/media-R -mapper "Rscript $HOME_R/prjmedia/mappermedia.R" -reducer "Rscript $HOME_R/prjmedia/reducermedia.R"
$HADOOP_HOME/bin/hdfs dfs -get /output/media-R/part-00000
$HOME_OUTPUT/output_MR_mediaR.txt

$HADOOP_HOME/bin/hdfs dfs -rm -R /output/varianza-R
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/varianza-R -mapper "Rscript $HOME_R/prjvarianza/mapvarianza.R" -reducer "Rscript $HOME_R/prjvarianza/reducevar.R"
$HADOOP_HOME/bin/hdfs dfs -get /output/varianza-R/part-00000
$HOME_OUTPUT/output_MR_varianzaR.txt

$HADOOP_HOME/bin/hdfs dfs -rm -R /output/min-R
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/min-R -mapper "Rscript $HOME_R/prjminr/mappermin.R" -reducer "Rscript $HOME_R/prjminr/reducemin.R"
$HADOOP_HOME/bin/hdfs dfs -get /output/min-R/part-00000
$HOME_OUTPUT/output_MR_minR.txt

$HADOOP_HOME/bin/hdfs dfs -rm -R /output/max-R
$HADOOP_HOME/bin/hadoop jar $HADOOP_STREAMING -input /tmp/Ordini.csv -output /output/max-R -mapper "Rscript $HOME_R/prjmaxr/mappermax.R" -reducer "Rscript $HOME_R/prjmaxr/reducemax.R"
$HADOOP_HOME/bin/hdfs dfs -get /output/max-R/part-00000
$HOME_OUTPUT/output_MR_maxR.txt