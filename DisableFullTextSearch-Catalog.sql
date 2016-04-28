declare @catid int

select @catid=fulltext_catalog_id from sys.fulltext_catalogs where name='CRMFullTextCatalog'

declare c cursor for

 select sys.tables.name, sys.fulltext_indexes.unique_index_id from sys.fulltext_indexes inner join sys.tables on sys.fulltext_indexes.object_id = sys.tables.object_id where sys.fulltext_indexes.fulltext_catalog_id=@catid

 open c

 declare @TableName varchar(200), @UniqueID as integer

 fetch next from c into @TableName, @UniqueID

 while @@fetch_status = 0

 begin

 declare d cursor for

 select sys.indexes.name, sys.tables.object_id from sys.tables inner join sys.indexes on sys.tables.object_id = sys.indexes.object_id where sys.tables.name=@TableName and sys.indexes.index_id = @UniqueID

 open d

 declare @KeyIndex varchar(200), @object_id as integer

 fetch next from d into @KeyIndex, @object_id

 if @@FETCH_STATUS <> 0 

 begin

 Print 'Error with' + @TableName

 end

 while @@fetch_status = 0

 begin

 BEGIN TRY

 Print 'CREATE FULLTEXT INDEX ON [dbo].'+@TableName+' KEY INDEX ['+@KeyIndex+'] on([CRMFullTextCatalog]) WITH (CHANGE_TRACKING AUTO)'

 Print 'GO'

 declare e cursor for

 select sys.columns.name from sys.columns inner join sys.fulltext_index_columns on sys.columns.object_id=sys.fulltext_index_columns.object_id and sys.columns.column_id=sys.fulltext_index_columns.column_id where sys.columns.object_id=@object_id

 open e

 declare @ColumnName varchar(200)

 fetch next from e into @ColumnName

 while @@fetch_status = 0

 begin

 Print 'ALTER FULLTEXT INDEX ON [dbo].'+@TableName+' Add ('+@ColumnName+')'

 Print 'GO'

 fetch next from e into @ColumnName

 end

 close e

 deallocate e

 END TRY

 BEGIN CATCH

 print 'Error' + @KeyIndex

 END CATCH

 fetch next from d into @KeyIndex, @object_id

 end

 close d

 deallocate d

 fetch next from c into @TableName, @UniqueID

 end

 close c

 deallocate c