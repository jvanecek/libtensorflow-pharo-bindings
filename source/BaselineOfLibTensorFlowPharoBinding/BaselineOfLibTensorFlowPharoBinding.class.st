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
				operationPackagesIn: spec;
				machineLearningPackagesIn: spec;
				experimentingPackageIn: spec.
			self
				coreGroupsIn: spec;
				operationGroupsIn: spec;
				machineLearningGroupsIn: spec;
				experimentingGroupsIn: spec.
			spec
				group: 'Development'
					with:
					#('Core-Development' 'Operations-Development' 'MachineLearning-Development' 'MachineLearning-Experimenting');
				group: 'CI' with: #('Core-Development' 'Operations-Development' 'MachineLearning-Development')
			]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> coreGroupsIn: spec [

	spec
		group: 'Core'
			with: #('TensorFlowCore' 'TensorFlowEnvironmentModel' 'VAST-Compatibility-Model' 'MLMathExtensions');
		group: 'Core-Development' with: #('Core' 'TensorFlowCoreTests' 'TensorFlowEnvironmentModelTests')
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> corePackagesIn: spec [

	spec
		package: 'TensorFlowCore' with: [ spec requires: #(IdxReader) ];
		package: 'TensorFlowCoreTests' with: [ spec requires: #('TensorFlowCore') ];
		package: 'TensorFlowEnvironmentModel'
			with: [ spec requires: #('TensorFlowCore' 'VAST-Compatibility-Model') ];
		package: 'TensorFlowEnvironmentModelTests'
			with: [ spec requires: #('TensorFlowEnvironmentModel') ];
		package: 'VAST-Compatibility-Model' with: [  ];
		package: 'MLMathExtensions' with: [  ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> experimentingGroupsIn: spec [

	spec
		group: 'Examples' with: #('LibTensorFlowExamplesApp');
		group: 'MachineLearning-Experimenting' with: #('MLTrainingVisualizationModel' 'Examples')
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> experimentingPackageIn: spec [

	spec
		package: 'LibTensorFlowExamplesApp' with: [ spec requires: #('TensorFlowCore' 'Roassal2') ];
		package: 'MLTrainingVisualizationModel' with: [ spec requires: #('MLTrainingModel' 'Roassal2') ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> idxReader: spec [
	spec baseline: 'IdxReader' with: [ spec repository: 'github://guillep/idx-reader' ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> machineLearningGroupsIn: spec [

	spec
		group: 'MachineLearning-Deployment'
			with:
			#('TFVariableSpecificationModel' 'TFRegularizationModel' 'TFDatasetModel' 'TFUtilityModel' 'MLNeuralNetworkLayerModel' 'TFOptimizerModel' 'MLTrainingMetricModel' 'DatasetProviderModel' 'MLTrainingLaboratoryModel');
		group: 'MachineLearning-Development'
			with:
			#('MachineLearning-Deployment' 'TFVariableSpecificationModelTests' 'TFRegularizationModelTests' 'TFUtilityModelTests' 'TFOptimizerModelTests' 'TFDatasetModelTests' 'MLNeuralNetworkLayerModelTests' 'MLTrainingMetricModelTests' 'MLTrainingModelTests' 'LibTensorFlowExamplesApp')
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> machineLearningPackagesIn: spec [

	spec
		package: 'TFVariableSpecificationModel' with: [ spec requires: #('TFOperationModel') ];
		package: 'TFVariableSpecificationModelTests'
			with: [ spec requires: #('TensorFlowEnvironmentModelTests' 'TFVariableSpecificationModel') ];
		package: 'TFRegularizationModel' with: [ spec requires: #('TFOperationModel') ];
		package: 'TFRegularizationModelTests'
			with: [ spec requires: #('TensorFlowEnvironmentModelTests' 'TFRegularizationModel') ];
		package: 'TFDatasetModel' with: [ spec requires: #('TFOperationModel') ];
		package: 'TFUtilityModel' with: [ spec requires: #('TFDatasetModel') ];
		package: 'TFUtilityModelTests'
			with: [ spec requires: #('TensorFlowEnvironmentModelTests' 'TFUtilityModel') ];
		package: 'MLNeuralNetworkLayerModel' with: [ spec requires: #('TFVariableSpecificationModel') ];
		package: 'MLNeuralNetworkLayerModelTests' with: [ spec requires: #('MLNeuralNetworkLayerModel') ];
		package: 'MLTrainingModel' with: [ spec requires: #('MLNeuralNetworkLayerModel') ];
		package: 'MLTrainingModelTests' with: [ spec requires: #('MLTrainingModel') ];
		package: 'TFOptimizerModel' with: [ spec requires: #('TFVariableSpecificationModel') ];
		package: 'TFOptimizerModelTests'
			with: [ spec requires: #('TensorFlowEnvironmentModelTests' 'TFOptimizerModel') ];
		package: 'MLTrainingMetricModel' with: [ spec requires: #('MLTrainingModel') ];
		package: 'MLTrainingMetricModelTests' with: [ spec requires: #('MLTrainingMetricModel') ];
		package: 'TFDatasetModelTests'
			with: [ spec requires: #('MLTrainingModel' 'TensorFlowEnvironmentModelTests' 'TFUtilityModel') ];
		package: 'DatasetProviderModel' with: [ spec requires: #('MLTrainingModel' 'TFDatasetModel') ];
		package: 'MLTrainingLaboratoryModel'
			with: [ spec requires: #('DatasetProviderModel' 'MLTrainingMetricModel' 'TFOptimizerModel') ];
		package: 'LibTensorFlowExamplesApp' with: [  ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> operationGroupsIn: spec [

	spec
		group: 'Operations-Runtime'
			with:
			#('TFTensorModifierModel' 'TFOperationModel' 'TFOperationGradientModel' 'TFVariableSpecificationModel');
		group: 'Operations-Development'
			with:
			#('Operations-Runtime' 'TFTensorModifierModelTests' 'TFOperationModelTests' 'TFOperationGradientFailingModelTests' 'TFOperationGradientModelTests' 'TFVariableSpecificationModelTests')
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> operationPackagesIn: spec [

	spec
		package: 'TFTensorModifierModel' with: [ spec requires: #('TensorFlowCore') ];
		package: 'TFTensorModifierModelTests'
			with: [ spec requires: #('TensorFlowEnvironmentModelTests' 'TFOperationModel') ];
		package: 'TFOperationModel'
			with: [ spec requires: #('TensorFlowEnvironmentModel' 'TFTensorModifierModel') ];
		package: 'TFOperationGradientModel' with: [ spec requires: #('TFOperationModel') ];
		package: 'TFOperationModelTests'
			with: [ spec requires: #('TensorFlowEnvironmentModelTests' 'TFOperationModel') ];
		package: 'TFOperationGradientFailingModelTests'
			with: [ spec requires: #('TFOperationGradientModelTests') ];
		package: 'TFOperationGradientModelTests'
			with: [ spec requires: #('TFOperationGradientModel' 'TFOperationModelTests') ]
]

{ #category : #baseline }
BaselineOfLibTensorFlowPharoBinding >> roassal2: spec [
	spec baseline: 'Roassal2' with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ]
]