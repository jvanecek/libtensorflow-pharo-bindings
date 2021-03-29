Extension { #name : #String }

{ #category : #'*VAST-Compatibility-Model' }
String >> subStrings: separators [
	"Synopsis
		Answer an array containing the substrings in the receiver
		separated by the elements of @separators.
		
	 Definition: <readableString>
		Answer an array of strings. Each element represents a group
		of characters separated by any of the characters in @separators.
		
	 Parameters
		separators <sequencedReadableCollection> uncaptured

	 Return Values
		<Array> unspecified

	 Errors
		If @separators contains anything other than Characters.

	 Implementation Notes
		The CLDT protocol says @separators is a single Character while
		the ANSI protocol says it is a collection of Characters.  This
		implementation supports both protocols.
		
		Consecutive separators are treated as a single separation point.
		
		Leading or trailing separators are ignored."

	| answer startIndex endIndex delimiters |

	answer := OrderedCollection new.
	delimiters := separators isCharacter 
		ifTrue: [ Array with: separators ]
		ifFalse: [ separators ].
	startIndex := 1.
	[ startIndex <= self size ] whileTrue: [
		endIndex := self findDelimiters: delimiters startingAt: startIndex.
		startIndex < endIndex
			ifTrue: [ answer add: (self copyFrom: startIndex to: endIndex - 1) ].
		startIndex := self skipDelimiters: delimiters startingAt: endIndex ].
	^ answer asArray	

]
