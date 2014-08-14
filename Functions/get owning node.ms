fn getOwner node=
(
for ref in refs.dependents node do if isValidNode ref then return ref
)

ca=$.baseobject.custAttributes[1]
caOwner=custAttributes.getOwner ca
theNode= getOwner caOwner

select theNode
