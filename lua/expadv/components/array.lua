/* ---	--------------------------------------------------------------------------------
	@: Array Component
   ---	*/

local Component = EXPADV.AddComponent( "arays" , true )

Component.Author = "Rusketh"
Component.Description = "Adds array objects."

Component:AddException( "array" )

/* ---	--------------------------------------------------------------------------------
	@: Table Class
   ---	*/

local Array = Component:AddClass( "array" , "ar" )

Array:DefaultAsLua( function( ) return {__type="void"} end )

Array:StringBuilder( function( A ) return string.format( "array<%s,%i>", EXPADV.TypeName(A.__type), #A ) end )

/* ---	--------------------------------------------------------------------------------
	@: Basic Operators
   ---	*/

EXPADV.SharedOperators( )

Array:AddPreparedOperator( "=", "n,ar", "", "Context.Memory[@value 1] = @value 2" ) -- Keeping this virtual, becuase i might need to add to it later :D

Component:AddInlineOperator( "#","ar","n", "#@value 1" )

Component:AddInlineOperator( "table", "ar", "t", "EXPADV.ResultTable(@value 1.__type, @value 1)" )

/* ---	--------------------------------------------------------------------------------
	@: Basic Functions
   ---	*/

Component:AddInlineFunction( "exists", "ar,n", "b", "(@value 1[@value 2] ~= nil)" )

Component:AddInlineFunction( "unpack", "ar", "...", "$unpack( @value 1 )" )

Component:AddPreparedFunction( "remove", "ar:n", "vr", [[
if @value 1[@value 2] == nil then Context.Throw(@trace, "array", "array reach index " .. @value 2 .. " returned void" ) end
]], "{$table.remove(@value 1, @value 2), @value 1.__type}" )

Component:AddPreparedFunction("connect", "ar:ar", "ar", [[
if @value 1.__type == @value 2.__type then
	for k,v in pairs(@value 2) do
		if v == @value 2.__type then continue end
		@value 1[#@value 1+1] = v
	end
else Context.Throw(@trace, "array", "array type missmatch, " .. EXPADV.TypeName(@value 1.__type) .. " expected got " .. EXPADV.TypeName(@value 2.__type)) end
]],"@value 1")
Component:AddFunctionHelper("connect", "ar:ar", "Connects one array with another array.")

/* --- --------------------------------------------------------------------------------
	@: Unpack to vararg
   --- */

local Unpack

function Unpack( Array, Index )
	if Array[Index] == nil then return end
	
	return { Array[Index], Array.__type }, Unpack( Array, Index + 1 )
end

Component:AddVMFunction( "unpack", "ar", "...", function( C, T, A ) return Unpack( A, 1 ) end )
Component:AddVMFunction( "unpack", "ar,n", "...", function( C, T, A, I ) return Unpack( A, I ) end )

Component:AddFunctionHelper( "unpack", "ar", "Unpacks an array to a vararg." )
Component:AddFunctionHelper( "unpack", "ar,n", "Unpacks an array to a vararg, staring at index N." )


function Component:OnPostRegisterClass( Name, Class )

	if Name == "generic" or Name == "function" or Name == "class" then return end

	if Class.LoadOnServer and Class.LoadOnClient then
		EXPADV.SharedOperators( )
	elseif Class.LoadOnServer then
		EXPADV.LoadOnClient( )
	elseif Class.LoadOnServer then
		EXPADV.ClientOperators( )
	end

/* ---	--------------------------------------------------------------------------------
	@: Get Operator
   ---	*/

	Array:AddPreparedOperator( "get", "ar,n," .. Class.Short, Class.Short, string.format([[
		if @value 1.__type ~= %q then Context.Throw(@trace, "array", "array type missmatch, %s expected got " .. EXPADV.TypeName(@value 1.__type)) end
		if @value 1[@value 2] == nil then Context.Throw(@trace, "array", "array reach index " .. @value 2 .. " returned void" ) end
		]], Class.Short, Class.Name), "@value 1[@value 2]")

/* ---	--------------------------------------------------------------------------------
	@: Set Operator
   ---	*/

	Array:AddPreparedOperator( "set", "ar,n," .. Class.Short, "", string.format([[
		if @value 1.__type ~= %q then Context.Throw(@trace, "array", "array type missmatch, %s expected got " .. EXPADV.TypeName(@value 1.__type)) end
		]], Class.Short, Class.Name), "@value 1[@value 2] = @value 3")

/* ---	--------------------------------------------------------------------------------
	@: Array builder
   ---	*/

   Component:AddGeneratedFunction( Class.Name .. "Array", "...", "ar",
		function( Operator, Compiler, Trace, ... )
			local Inputs = { ... }
			local Preperation = { }
			local Values = { }

			for I = 1, #Inputs, 1 do
				local Input = Inputs[I]

				if Input.Return ~= Class.Short then
					Compiler:TraceError(Trace, "Array of type %s must not contain value of type %s", Compiler:NiceClass(Class.Short, Input.Return or "void") )
				end

				if Input.FLAG == EXPADV_PREPARE or Input.FLAG == EXPADV_INLINEPREPARE then
					Preperation[#Preperation + 1] = Input.Prepare
				end

				if Input.FLAG == EXPADV_INLINE or Input.FLAG == EXPADV_INLINEPREPARE then
					Values[I] = Input.Inline
				end
			end

			local LuaInline = string.format( "{ __type = %q, %s }", Class.Short, table.concat( Values, "," ) )

			return { Trace = Trace, Inline = LuaInline, Prepare = table.concat( Preperation, "\n" ), Return = "_ar", FLAG = EXPADV_INLINEPREPARE }
		end )

/* ---	--------------------------------------------------------------------------------
	@: Functions
   ---	*/

	Component:AddPreparedFunction( "remove" .. Class.Name, "ar:n", Class.Short, string.format([[
		if @value 1.__type ~= %q then Context.Throw(@trace, "array", "array type missmatch, %s expected got " .. EXPADV.TypeName(@value 1.__type)) end
		if @value 1[@value 2] == nil then Context.Throw(@trace, "array", "array reach index " .. @value 2 .. " returned void" ) end
		]], Class.Short, Class.Name), "$table.remove(@value 1, @value 2)")

	Component:AddPreparedFunction( "insert", "ar:n," .. Class.Short, "", string.format([[
		if @value 1.__type ~= %q then Context.Throw(@trace, "array", "array type missmatch, %s expected got " .. EXPADV.TypeName(@value 1.__type)) end
		]], Class.Short, Class.Name), "$table.insert(@value 1, @value 2, @value 3)")
	EXPADV.AddFunctionAlias("insert", "ar,n," .. Class.Short)

	Component:AddPreparedFunction( "insert", "ar:" .. Class.Short, "", string.format([[
		if @value 1.__type ~= %q then Context.Throw(@trace, "array", "array type missmatch, %s expected got " .. EXPADV.TypeName(@value 1.__type)) end
		]], Class.Short, Class.Name), "$table.insert(@value 1, @value 2)")
	EXPADV.AddFunctionAlias("insert", "ar," .. Class.Short)

/* ---	--------------------------------------------------------------------------------
	@: Foreach Loop
   ---	*/

   Array:AddPreparedOperator( "foreach", Array.Short .. ",n," .. Class.Short, "", [[
   		if @value 1.__type ~= "]] ..Class.Short .. [[" then Context.Throw(@trace, "array", "array type missmatch, ]] .. Class.Name .. [[ expected got " .. EXPADV.TypeName(@value 1.__type)) end

   		for i = 1, #@value 1 do
   			local value = @value 1[i]
   			@prepare 2
   		end]] )
end

/* ---	--------------------------------------------------------------------------------
	@: VON Support
	---	*/

Array:AddSerializer( function( Array )

	if !EXPADV.CanSerialize(Array.__type) then return end

	local Clone = { __type = Array.__type }

	for Key, Value in pairs( Array ) do
		if Key == "__type" then continue end

		Clone[Key] = EXPADV.Serialize( Array.__type, Value )
	end

	return Clone
end )

Array:AddDeserializer( function( Array )

	local Clone = { __type = Array.__type }

	for Key, Value in pairs( Array ) do
		if Key == "__type" then continue end

		Clone[Key] = EXPADV.Deserialize( Array.__type, Value )
	end

	return Clone
end )