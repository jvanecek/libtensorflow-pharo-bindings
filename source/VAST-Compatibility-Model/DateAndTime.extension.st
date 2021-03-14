Extension { #name : #DateAndTime }

{ #category : #'*VAST-Compatibility-Model' }
DateAndTime >> asMilliseconds [

	^ self asNanoSeconds * 1e-6
]
