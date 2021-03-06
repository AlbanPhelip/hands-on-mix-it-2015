package com.xebia.spark.randomForestClassification.solution


import com.xebia.spark.randomForestClassification.solution.features.Engineering
import com.xebia.spark.randomForestClassification.solution.tools.Utilities._
import com.xebia.spark.randomForestClassification.solution.modelling.TreeModelling.randomForestTrainClassifier
import org.apache.spark.{SparkContext, SparkConf}


object RandomForestClassification {

  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("RandomForest").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    // Loading data
    val rawData = sc.textFile("./src/main/resources/data_titanic.csv")

    // Parsing Data
    val data = extractHeader(rawData)._2

    // Feature Engineering
    val cleanData = Engineering.featureEngineering(data)

    // Splitting data
    val Array(trainSet, testSet) = cleanData.randomSplit(Array(0.75, 0.25))

    // Modelling
    // -------- Tuning parameters
    val categoricalFeaturesInfo = Map(1 -> 2, 6 -> 4)

    // -------- Training the model
    val model = randomForestTrainClassifier(categoricalFeaturesInfo = categoricalFeaturesInfo, numTrees = 50,
      impurity = "entropy", maxDepth = 10, maxBins = 50)(trainSet)

    // Prediction & Evaluation
    val (accuracyTrain, confusionTrain) = getMetricsRandomForest(model, trainSet)
    val (accuracyTest, confusionTest) = getMetricsRandomForest(model, testSet)

    // Print results
    println(s"Results for the training set")
    println(s"\t Accuracy: $accuracyTrain %")
    println(s"\t Confusion Matrix: \n $confusionTrain")

    println(s"Results for the test set")
    println(s"\t Accuracy: $accuracyTest %")
    println(s"\t Confusion Matrix: \n $confusionTest")


  }




}
