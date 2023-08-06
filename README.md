# FamilyTreeCli
<https://github.com/anshumanjio75/family_tree_cli>

```elixir
**Run**
mix escript.build
__________________________________________________
Add:
./family-tree add Amit Dhakad
./family-tree add relationship father
./family-tree add relationship son

Connect:
./family-tree connect Amit Dhakad as son of KK Dhakad

./family-tree connect Jhon as son of Amit
./family-tree connect Sam as son of Jhon
./family-tree connect Ron as son of Jhon
./family-tree grandsons of Amit
./family-tree grandfather of Ron

Query:
./family-tree count sons of KK Dhakad
./family-tree count daughters of KK Dhakad
./family-tree son of KK Dhakad

_________________________________________________
./family-tree connect anshu as brother of mithu
./family-tree connect mithu as sister of anshu
./family-tree connect aditya as husband of ruma
./family-tree connect mithu as daughter of aditya
./family-tree children of aditya
./family-tree connect aditya as father of anshu
./family-tree connect ruma as mother of anshu
./family-tree connect ruma as mother of mithu
./family-tree sisters of anshu
./family-tree childrens of ruma
./family-tree count childrens of ruma
```
