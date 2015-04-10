package com.xebia.spark.kMeansClustering.stubs.tools

import org.apache.spark.mllib.clustering.KMeansModel
import org.apache.spark.mllib.evaluation.MulticlassMetrics
import org.apache.spark.rdd.RDD
import org.apache.spark.mllib.linalg.{Matrix, Vector}


object Utilities {

  /**
   * Extract header of a dataset
   * @param rdd A RDD with a header inside
   * @return A tuple2. First element of the tuple is the header. Second element is the data.
   */
  def extractHeader(rdd: RDD[String]): (String, RDD[String]) = {

    // Take the first line (csv schema)
    val schema = rdd.first()

    // Remove first line from first partition only
    (schema, rdd.mapPartitionsWithIndex( (partitionIdx: Int, lines: Iterator[String]) => {
      if (partitionIdx == 0) {
        lines.drop(1)
      }
      else {
        lines
      }
    }))
  }


  /**
   *
   * @param model A KMeansModel from the methos Kmeans.train()
   * @param data the data (a RDD[Vector])
   * @param labels The labels (a RDD[Double])
   * @return A tuple giving the accuracy and the confusion matrix
   */
  def getMetrics(model: KMeansModel, data: RDD[Vector], labels: RDD[Double]): (Double, Matrix) = {

    val predictionsAndLabels = data.zip(labels).map(l => (model.predict(l._1).toDouble, l._2))
    val metrics: MulticlassMetrics = new MulticlassMetrics(predictionsAndLabels)

    val accuracy = if(metrics.precision > 0.5) 1d - metrics.precision else metrics.precision
    val confusion = metrics.confusionMatrix

    (accuracy, confusion)
  }






}