Class {
	#name : #BaselineOfLibTensorFlowPharoBinding,
	#superclass : #BaselineOf,
	#category : #BaselineOfLibTensorFlowPharoBinding
}

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> baseline: spec [

	<baseline>
	spec
		for: #common
		do: [ self
				idxReader: spec;
				roassal2: spec.
			self
				corePackagesIn: spec;
				tensorFlowComputationPackagesIn: spec;
				neuralNetworkTrainingPackagesIn: spec;
				experimentingPackageIn: spec.
			self
				coreGroupsIn: spec;
				tensorFlowComputationGroupsIn: spec;
				neuralNetworkTrainingGroupsIn: spec;
				experimentingGroupsIn: spec.
			spec
				group: 'Development'
					with:
					#('Core-Development' 'Computation-Development' 'MachineLearning-Development' 'MachineLearning-Experimenting');
				group: 'CI' with: #('Core-Development' 'Computation-Development' 'MachineLearning-Development');
				group: 'Deprecated'
					with: #('TensorFlowDeprecatedCore' 'TensorFlowDeprecatedCoreTests' 'TensorFlowEnvironmentDeprecatedModel')
			]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> coreGroupsIn: spec [

	spec
		group: 'Core' with: #( 'TensorFlowCore' 'TensorFlowPharoCore' 'VAST-Compatibility-Model' );
		group: 'Core-Development' with: #( 'Core' 'TensorFlowCoreTests' )
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> corePackagesIn: spec [

	spec
		package: 'TensorFlowCore' with: [ spec requires: #(IdxReader) ];
		package: 'TensorFlowCoreTests' with: [ spec requires: #('TensorFlowCore') ];
		package: 'TensorFlowPharoCore' with: [ spec requires: #('TensorFlowCore' ) ];
		package: 'VAST-Compatibility-Model' with: [  ];
		package: 'MLMathExtensions' with: [  ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> experimentingGroupsIn: spec [

	spec
		group: 'Examples' with: #('LibTensorFlowExamplesApp' 'LibTensorFlowExamplesTestsApp');
		group: 'MachineLearning-Experimenting' with: #('NeuralNetworkTrainingVisualizationModel' 'TensorFlowOperationExperimentalModel' 'TensorFlowOperationExperimentalModelTests' 'Examples')
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> experimentingPackageIn: spec [

	spec
		package: 'LibTensorFlowExamplesApp' with: [ spec requires: #('TensorFlowCore' 'Roassal2') ];
		package: 'LibTensorFlowExamplesTestsApp' with: [ spec requires: #('LibTensorFlowExamplesApp' 'TensorFlowComputationModelTests') ];
		package: 'NeuralNetworkTrainingVisualizationModel' with: [ spec requires: #('NeuralNetworkTrainingModel' 'Roassal2') ];
		
		package: 'TensorFlowOperationExperimentalModel' with: [ spec requires: #('TensorFlowOperationBasicModel') ];
		package: 'TensorFlowOperationExperimentalModelTests' with: [ spec requires: #('TensorFlowOperationExperimentalModel' 'TensorFlowComputationModelTests') ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> idxReader: spec [
	spec baseline: 'IdxReader' with: [ spec repository: 'github://guillep/idx-reader' ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> neuralNetworkTrainingGroupsIn: spec [

	spec
		group: 'MachineLearning-Deployment'
		with:
			#( 'NeuralNetworkLayerModel' 'NeuralNetworkTrainingModel' 'NeuralNetworkTrainingMetricModel'
			   'NeuralNetworkTrainingOptimizerModel' 'NeuralNetworkTrainingDatasetModel' );
		group: 'MachineLearning-Development'
		with: #( 'NeuralNetworkLayerModelTests' 'NeuralNetworkTrainingModelTests'
			   'NeuralNetworkTrainingMetricModelTests' 'NeuralNetworkTrainingOptimizerModelTests'
			   'NeuralNetworkTrainingDatasetModelTests' )
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> neuralNetworkTrainingPackagesIn: spec [

	spec
		package: 'NeuralNetworkLayerModel' with: [ spec requires: #('TensorFlowOperationBasicModel' ) ];
		package: 'NeuralNetworkLayerModelTests' with: [ spec requires: #('TensorFlowComputationModelTests' 'NeuralNetworkLayerModel') ];
		package: 'NeuralNetworkTrainingModel' with: [ spec requires: #('TensorFlowOperationMathModel') ];
		package: 'NeuralNetworkTrainingModelTests' with: [ spec requires: #('TensorFlowComputationModelTests' 'NeuralNetworkLayerModel' 'NeuralNetworkTrainingDatasetModel' 'NeuralNetworkTrainingMetricModel' 'NeuralNetworkTrainingOptimizerModel') ];
		package: 'NeuralNetworkTrainingMetricModel' with: [ spec requires: #('NeuralNetworkTrainingModel' ) ];
		package: 'NeuralNetworkTrainingMetricModelTests' with: [ spec requires: #('NeuralNetworkTrainingModelTests' 'NeuralNetworkTrainingMetricModel') ];
		package: 'NeuralNetworkTrainingOptimizerModel' with: [ spec requires: #('TensorFlowOperationMathModel') ];
		package: 'NeuralNetworkTrainingOptimizerModelTests' with: [ spec requires: #('TensorFlowComputationModelTests' 'NeuralNetworkTrainingOptimizerModel') ];
		package: 'NeuralNetworkTrainingDatasetModel' with: [ spec requires: #('TensorFlowDatasetModel') ];
		package: 'NeuralNetworkTrainingDatasetModelTests' with: [ spec requires: #('TensorFlowComputationModelTests' 'NeuralNetworkTrainingDatasetModel') ];
		package: 'NeuralNetworkTrainingLaboratory' with: [ spec requires: #('NeuralNetworkLayerModel' 'NeuralNetworkTrainingDatasetModel' 'NeuralNetworkTrainingMetricModel' 'NeuralNetworkTrainingOptimizerModel') ];
		package: 'LibTensorFlowExamplesApp' with: [  ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> roassal2: spec [
	spec baseline: 'Roassal2' with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> tensorFlowComputationGroupsIn: spec [

	spec
		group: 'Computation-Runtime'
		with:
			#( 'TensorFlowComputationModel' 'TensorFlowOperationBasicModel' 'TensorFlowOperationMathModel'
			   'TensorFlowOperationRandomModel' 'TensorFlowOperationGradientModel'
			   'TensorFlowDatasetModel' );
		group: 'Computation-Development'
		with: #( 'TensorFlowComputationModelTests' 'TensorFlowOperationBasicModelTests'
			   'TensorFlowOperationMathModelTests' 'TensorFlowOperationRandomModelTests'
			   'TensorFlowOperationGradientModelTests' 'TensorFlowDatasetModelTests' )
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> tensorFlowComputationPackagesIn: spec [
	
	spec
		package: 'TensorFlowComputationModel' with: [ spec requires: #('TensorFlowCore' 'VAST-Compatibility-Model') ];
		package: 'TensorFlowComputationModelTests' with: [ spec requires: #('TensorFlowComputationModel') ];
		package: 'TensorFlowOperationBasicModel' with: [ spec requires: #('TensorFlowComputationModel') ];
		package: 'TensorFlowOperationBasicModelTests' with: [ spec requires: #('TensorFlowOperationBasicModel' 'TensorFlowComputationModelTests') ];
		package: 'TensorFlowOperationMathModel' with: [ spec requires: #('TensorFlowOperationBasicModel') ];
		package: 'TensorFlowOperationMathModelTests' with: [ spec requires: #('TensorFlowOperationMathModel' 'TensorFlowComputationModelTests') ];		
		package: 'TensorFlowOperationGradientModel' with: [ spec requires: #('TensorFlowOperationBasicModel') ];
		package: 'TensorFlowOperationGradientModelTests' with: [ spec requires: #('TensorFlowOperationGradientModel' 'TensorFlowComputationModelTests') ];	
		package: 'TensorFlowOperationRandomModel' with: [ spec requires: #('TensorFlowOperationBasicModel') ];
		package: 'TensorFlowOperationRandomModelTests' with: [ spec requires: #('TensorFlowComputationModelTests' 'TensorFlowOperationRandomModel') ];
		package: 'TensorFlowDatasetModel' with: [ spec requires: #('TensorFlowOperationBasicModel') ];
		package: 'TensorFlowDatasetModelTests' with: [ spec requires: #('TensorFlowOperationBasicModel' 'TensorFlowDatasetModel') ]
]
