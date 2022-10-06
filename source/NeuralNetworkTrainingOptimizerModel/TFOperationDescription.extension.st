Extension { #name : #TFOperationDescription }

{ #category : #'*NeuralNetworkTrainingOptimizerModel' }
TFOperationDescription >> atUseNesterovPut: aBoolean [

	self at: TFAttributeName useNesterov putBoolean: aBoolean
]
