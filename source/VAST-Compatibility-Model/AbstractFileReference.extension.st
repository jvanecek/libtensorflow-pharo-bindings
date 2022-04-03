Extension { #name : #AbstractFileReference }

{ #category : #'*VAST-Compatibility-Model' }
AbstractFileReference >> allFileAndDirectoryEntries [

	^ self allChildren copyWithoutFirst sorted: [ :a :b | a pathString < b pathString  ]
]
