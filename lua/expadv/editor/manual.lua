local SearchQuery = ""
local LabelColor = Color(0, 0, 0, 255)

local PANEL = { }

	function PANEL:Init( )
		self.Lines = { }
		self.Expanded = true

		self.Label = self:Add( "EA_Button" )
		self.Contents = vgui.Create( "DListView", self )

		function self.Label.DoClick( )
			self.Expanded = !self.Expanded
			self:GetParent( ):PerformLayout( )
		end
	end

	function PANEL:SetLabel( Text )
		self.LabelText = Text
		self.Label:SetText( Text )
	end

	function PANEL:Clear( )
		self.Lines = { }
		self.Contents:Clear( )
	end

	function PANEL:AddColumn( Name, Size )
		local Colum = self.Contents:AddColumn( Name )
		if Colum and Size then Colum:SetFixedWidth( Size ) end
		return Colum
	end

	function PANEL:AddLine( ... )
		self.Lines[#self.Lines + 1] = { ... }
		return self.Contents:AddLine( ... )
	end

	function PANEL:PerformLayout( )
		self:SetWide( self:GetParent( ):GetWide( ) )

		self.Label:SetSize( self:GetWide( ), 22 )
		self.Label:SetPos( 5, 5 )

		if !self.Expanded then
			self.Contents:SetSize( 0, 0 )
			self.Contents:SetVisible( true )
		else
			self.Contents:PerformLayout( )
			self.Contents:SetVisible( true )
			self.Contents:SetPos( 5, 10 + self.Label:GetTall( ) )
			self.Contents:SetSize( self:GetWide( ), self.Contents:DataLayout( ) + self.Contents:GetHeaderHeight( ) )
		end

		self:SetTall( self.Label:GetTall( ) + self.Contents:GetTall( ) + 15 )
	end

	function PANEL:Search( Query )
		self.Contents:Clear( )

		local TotalResults = 0

		for I = 1, #self.Lines do
			local AddLine = false
			local Line = self.Lines[I]

			for J = 1, #Line do
				if Query ~= "" and !string.find( string.lower(Line[J]), Query, 1, true ) then continue end
				AddLine = true
				break
			end

			if !AddLine then continue end

			TotalResults = TotalResults + 1
			self.Contents:AddLine( Line[1], Line[2], Line[3], Line[4], Line[5], Line[6] )
		end

		if TotalResults == 0 then
			self.Label:SetText( self.LabelText .. " - (No Results)" )
		elseif TotalResults < #self.Lines then
			self.Label:SetText( self.LabelText .. " - (" .. TotalResults .. " Results)" )
		else
			self.Label:SetText( self.LabelText )
		end
	end

vgui.Register( "EA_HelpList", PANEL, "DPanel" )

------------------------------------------- ------------------------------------------- -------------------------------------------

local PANEL = { }

function PANEL:MakeInfoSheet( )
	if IsValid( self.Sheet_Info ) then return end
	self.Sheet_Info = self:Add( "EA_HelpList" )
	self.Sheet_Info:SetLabel( "Information" )

	self.Sheet_Info:AddColumn( "", 60 )
	self.Sheet_Info:AddColumn( "" )
end

function PANEL:GetInfoSheet( )
	if !IsValid( self.Sheet_Info ) then self:MakeInfoSheet( ) end
	return self.Sheet_Info
end

function PANEL:MakeSettingSheet( )
	if IsValid( self.Sheet_Setting ) then return end
	self.Sheet_Setting = self:Add( "EA_HelpList" )
	self.Sheet_Setting:SetLabel( "Settings" )

	self.Sheet_Setting:AddColumn( "Setting Name" )
	self.Sheet_Setting:AddColumn( "Value" )
end

function PANEL:GetSettingSheet( )
	if !IsValid( self.Sheet_Setting ) then self:MakeSettingSheet( ) end
	return self.Sheet_Setting
end

function PANEL:MakeOperatorSheet( )
	if IsValid( self.Sheet_Operator ) then return end
	self.Sheet_Operator = self:Add( "EA_HelpList" )
	self.Sheet_Operator:SetLabel( "Operators" )

	self.Sheet_Operator:AddColumn( "Avalibility", 60 )
	self.Sheet_Operator:AddColumn( "Operator",  70 )
	self.Sheet_Operator:AddColumn( "Return",  60 )
	self.Sheet_Operator:AddColumn( "Example" )
	self.Sheet_Operator:AddColumn( "Description" )
end

function PANEL:GetOperatorSheet( )
	if !IsValid( self.Sheet_Operator ) then self:MakeOperatorSheet( ) end
	return self.Sheet_Operator
end

function PANEL:MakeFunctionSheet( )
	if IsValid( self.Sheet_Function ) then return end
	self.Sheet_Function = self:Add( "EA_HelpList" )
	self.Sheet_Function:SetLabel( "Functions" )

	self.Sheet_Function:AddColumn( "Avalibility", 60 )
	self.Sheet_Function:AddColumn( "Return", 60 )
	self.Sheet_Function:AddColumn( "Function" )
	self.Sheet_Function:AddColumn( "Description" )
end

function PANEL:GetFunctionSheet( )
	if !IsValid( self.Sheet_Function ) then self:MakeFunctionSheet( ) end
	return self.Sheet_Function
end

function PANEL:MakeMethodSheet( )
	if IsValid( self.Sheet_Method ) then return end
	self.Sheet_Method = self:Add( "EA_HelpList" )
	self.Sheet_Method:SetLabel( "Methods" )

	self.Sheet_Method:AddColumn( "Avalibility", 60 )
	self.Sheet_Method:AddColumn( "Return", 60 )
	self.Sheet_Method:AddColumn( "Method" )
	self.Sheet_Method:AddColumn( "Description" )
end

function PANEL:GetMethodSheet( )
	if !IsValid( self.Sheet_Method ) then self:MakeMethodSheet( ) end
	return self.Sheet_Method
end

function PANEL:MakeEventSheet( )
	if IsValid( self.Sheet_Event ) then return end
	self.Sheet_Event = self:Add( "EA_HelpList" )
	self.Sheet_Event:SetLabel( "Events" )

	self.Sheet_Event:AddColumn( "Avalibility", 60 )
	self.Sheet_Event:AddColumn( "Return", 60 )
	self.Sheet_Event:AddColumn( "Event" )
	self.Sheet_Event:AddColumn( "Description" )
end

function PANEL:GetEventSheet( )
	if !IsValid( self.Sheet_Event ) then self:MakeEventSheet( ) end
	return self.Sheet_Event
end

function PANEL:Search( Query )
	if IsValid( self.Sheet_Function ) then
		self.Sheet_Function:Search( Query )
	end

	if IsValid( self.Sheet_Method ) then
		self.Sheet_Method:Search( Query )
	end

	if IsValid( self.Sheet_Event ) then
		self.Sheet_Event:Search( Query )
	end

	if IsValid( self.Sheet_Operator ) then
		self.Sheet_Operator:Search( Query )
	end

	if IsValid( self.Sheet_Info ) then
		self.Sheet_Info.Expanded = Query == ""
	end

	if IsValid( self.Sheet_Info ) then
		self.Sheet_Info.Expanded = Query == ""
	end

	self:PerformLayout( )
end

function PANEL:PerformLayout( )
	local X, Y = 5, 5
	self:SetWide( self:GetParent( ):GetWide( ) )

	if IsValid( self.Sheet_Info ) then
		self.Sheet_Info:PerformLayout( )
		self.Sheet_Info:SetPos( X, Y )
		self.Sheet_Info:SetWide( self:GetWide( ) )
		Y = Y + self.Sheet_Info:GetTall( ) + 5
	end

	if IsValid( self.Sheet_Setting ) then
		self.Sheet_Setting:PerformLayout( )
		self.Sheet_Setting:SetPos( X, Y )
		self.Sheet_Setting:SetWide( self:GetWide( ) )
		Y = Y + self.Sheet_Setting:GetTall( ) + 5
	end

	if IsValid( self.Sheet_Operator ) then
		self.Sheet_Operator:PerformLayout( )
		self.Sheet_Operator:SetPos( X, Y )
		self.Sheet_Operator:SetWide( self:GetWide( ) )
		Y = Y + self.Sheet_Operator:GetTall( ) + 5
	end

	if IsValid( self.Sheet_Function ) then
		self.Sheet_Function:PerformLayout( )
		self.Sheet_Function:SetPos( X, Y )
		self.Sheet_Function:SetWide( self:GetWide( ) )
		Y = Y + self.Sheet_Function:GetTall( ) + 5
	end

	if IsValid( self.Sheet_Method ) then
		self.Sheet_Method:PerformLayout( )
		self.Sheet_Method:SetPos( X, Y )
		self.Sheet_Method:SetWide( self:GetWide( ) )
		Y = Y + self.Sheet_Method:GetTall( ) + 5
	end

	if IsValid( self.Sheet_Event ) then
		self.Sheet_Event:PerformLayout( )
		self.Sheet_Event:SetPos( X, Y )
		self.Sheet_Event:SetWide( self:GetWide( ) )
		Y = Y + self.Sheet_Event:GetTall( ) + 5
	end

	self:SetTall( Y + 5 )
end

vgui.Register( "EA_HelpPage", PANEL, "DPanel" )

------------------------------------------- ------------------------------------------- -------------------------------------------

local function GetAvalibility( Operator )
	if Operator.LoadOnServer and Operator.LoadOnClient then return "Shared" end
	if Operator.LoadOnServer then return "Serverside" end
	if Operator.LoadOnClient then return "Clientside" end
	return "Unkown"
end

local function NamePerams( Perams, Count, Varg )
	local Names = { }

	for I = 1, Count do
		if Perams[I] == "" or Perams[I] == "..." then break end
		Names[I] = EXPADV.TypeName( Perams[I] or "" )
		if Names[I] == "void" then Names[I] = nil; break end
	end
		
	if Varg then table.insert( Names, "..." ) end

	return table.concat( Names, ", " )
end

------------------------------------------- ------------------------------------------- -------------------------------------------

function EXPADV.AddHelperTab( TabSheet, ToolBar )
	
		local NodeList = vgui.Create( "DTree" )
		NodeList:SetVisible( false )
		NodeList:Dock( FILL )

		local BrowserCanvas = vgui.Create(  "DScrollPanel" )
		BrowserCanvas:SetVisible( false )
		BrowserCanvas:Dock( FILL )

		local BrowserSheet = BrowserCanvas:Add( "EA_HelpPage" )
		BrowserSheet:Dock( FILL )

	-- ToolBar:
		ToolBar:SetupButton( "Open user manual", Material( "fugue/question.png" ), LEFT,
			function( )
				if !TabSheet.NodeTab then
					TabSheet.NodeTab = TabSheet:AddSheet( "Components", NodeList, nil, true, true, "Best place for help." ).Tab
					TabSheet:SetActiveTab( TabSheet.NodeTab )
				end
			end ) 

		ToolBar:SetupButton( "Open browser", Material( "fugue/rocket-fly.png" ), LEFT,
			function( )
				-- if !TabSheet.BrowserTab then
				-- 	TabSheet.BrowserTab = TabSheet:AddSheet( "Browser", BrowserCanvas, nil, true, true, "Browse" ).Tab
				-- 	TabSheet:SetActiveTab( TabSheet.BrowserTab )
				-- end

				local CodeTabs = ToolBar:GetParent().TabHolder
				CodeTabs:SetActiveTab( CodeTabs:AddSheet( "Browser", BrowserCanvas, nil, true, true, "Browse" ).Tab )
			end ) 

	-- COMPONENTS & CLASSES:

		local ClassPanels = { }
		local ComponentPanels = { }

		local function GetComponentPanel( Name, bNoCreate )
			if !Name then
				Name = "core"
			elseif type( Name ) == "table" then
				Name = Name.Name or "core"
			end
			
			if ComponentPanels[Name] then
				return ComponentPanels[Name]
			end

			if !bNoCreate then
				local ScrollPanel = vgui.Create( "DScrollPanel" )
				ScrollPanel:Dock( FILL )
				ScrollPanel:SetVisible(false)

				local Pnl = ScrollPanel:Add( "EA_HelpPage" )
				Pnl:Dock( FILL )
				Pnl.ScrollPanel = ScrollPanel

				ComponentPanels[Name] = Pnl

				return Pnl
			end
		end

		local function GetClassPanel( Name, bNoCreate )
			if !Name then return end
			
			if ClassPanels[Name] then
				return ClassPanels[Name]
			end

			if !bNoCreate then
				local ScrollPanel = vgui.Create( "DScrollPanel" )
				ScrollPanel:DockMargin( 5, 5, 5 ,5 )
				ScrollPanel:Dock( FILL )
				ScrollPanel:SetVisible(false)

				local Pnl = ScrollPanel:Add( "EA_HelpPage" )
				Pnl:Dock( FILL )
				Pnl.ScrollPanel = ScrollPanel
				ClassPanels[Name] = Pnl
				return Pnl
			end
		end

		local SearchQuery = ""

		local function SetActiveComponentPage( Name )
			local Page = GetComponentPanel( Name, true )
			if !IsValid( Page ) then return end

			local CodeTabs = ToolBar:GetParent().TabHolder
			CodeTabs:SetActiveTab( CodeTabs:AddSheet( Name, Page.ScrollPanel, nil, true, true, "Help: " .. Name ).Tab )
		end

		local function SetActiveClassPage( Name )
			local Page = GetClassPanel( Name, true )
			if !IsValid( Page ) then return end

			local CodeTabs = ToolBar:GetParent().TabHolder
			CodeTabs:SetActiveTab( CodeTabs:AddSheet( Name, Page.ScrollPanel, nil, true, true, "Help: " .. Name ).Tab )
		end

	-- NODES:

		local ComponentNodes = { }

		local RootComponentNode = NodeList:AddNode( "Components" )
		RootComponentNode:SetExpanded( true )

		local function GetComponentNode( Name, bNoCreate )
			if !Name then
				Name = "core"
			elseif type( Name ) == "table" then
				Name = Name.Name or "core"
			end
			
			if ComponentNodes[Name] then
				return ComponentNodes[Name]
			end

			if !bNoCreate then
				local Node = RootComponentNode:AddNode( Name )
				Node:SetIcon( "fugue/document-node.png" )
				ComponentNodes[Name] = Node
				return Node
			end
		end

	-- COMPONENT PAGES:

		local CoreComponentPage = GetComponentPanel( "core" )
		
		CoreComponentPage:GetInfoSheet( ):AddLine( "Component", "Core" )
		CoreComponentPage:GetInfoSheet( ):AddLine( "Author", "Rusketh" ) 
		CoreComponentPage:GetInfoSheet( ):AddLine( "Description", "Primary structure of Expression Advanced 2." )
		
		local CoreComponentNode = GetComponentNode( "core" )

		function CoreComponentNode:DoClick( )
			SetActiveComponentPage( "core" )
		end

		for _, Component in pairs( EXPADV.Components ) do
			local Page = GetComponentPanel( Component.Name )

			Page:GetInfoSheet( ):AddLine( "Component", Component.Name )
			Page:GetInfoSheet( ):AddLine( "Author", Component.Author or "Unkown" ) 
			Page:GetInfoSheet( ):AddLine( "Status", Component.Enabled and "Enabled" or "Disabled" )
			Page:GetInfoSheet( ):AddLine( "Description", Component.Description or "N/A" )

			if EXPADV.Config.components[Component.Name] then
				for Name, Value in pairs( EXPADV.Config.components[Component.Name] ) do
					if isbool( Value ) or isnumber( Value ) or isstring( Value ) then
						Page:GetSettingSheet( ):AddLine( Name, tostring( Value ) )
					end
				end
			end

			local Node = GetComponentNode( Component.Name )

			function Node:DoClick( )
				SetActiveComponentPage( Component.Name )
			end
		end

	-- OPERATORS:

		local CLASS_OPERATORS = { }

		for Sig, Operator in pairs( EXPADV.Operators ) do
			
			if Operator.InputCount == 0 or !Operator.Example or Operator.Example == "" then
				continue
			end

			if Operator.AttachedClass then
				CLASS_OPERATORS[Sig] = Operator
				continue
			end
			
			local Page = GetComponentPanel( Operator.Component )

			Page:GetOperatorSheet( ):AddLine( GetAvalibility(Operator), Operator.Type or "", EXPADV.TypeName( Operator.Return or "" ) or "void", Operator.Example, Operator.Description )
			BrowserSheet:GetOperatorSheet( ):AddLine( GetAvalibility(Operator), Operator.Type or "", EXPADV.TypeName( Operator.Return or "" ) or "void", Operator.Example, Operator.Description )
		end

		for Sig, Operator in pairs( CLASS_OPERATORS ) do
			local Page = GetClassPanel( Operator.AttachedClass )

			Page:GetOperatorSheet( ):AddLine( GetAvalibility(Operator), Operator.Type or "", EXPADV.TypeName( Operator.Return or "" ) or "void", Operator.Example, Operator.Description )
			BrowserSheet:GetOperatorSheet( ):AddLine( GetAvalibility(Operator), Operator.Type or "", EXPADV.TypeName( Operator.Return or "" ) or "void", Operator.Example, Operator.Description )
		end

	-- FUNCTIONS:

		local METHOD_QUEUE = { }

		for Sig, Operator in pairs( EXPADV.Functions ) do
			
			if Operator.Method then
				METHOD_QUEUE[Sig] = Operator
				continue
			end

			local Page = GetComponentPanel( Operator.Component )

			local Signature = string.format( "%s(%s)", Operator.Name, NamePerams( Operator.Input, Operator.InputCount, Operator.UsesVarg ) )
				
			Page:GetFunctionSheet( ):AddLine( GetAvalibility(Operator), EXPADV.TypeName( Operator.Return or "" ) or "Void", Signature, Operator.Description )
			BrowserSheet:GetFunctionSheet( ):AddLine( GetAvalibility(Operator), EXPADV.TypeName( Operator.Return or "" ) or "Void", Signature, Operator.Description )
		end

	-- METHODS:

		for Sig, Operator in pairs( METHOD_QUEUE ) do
			local ClassPage = GetClassPanel( Operator.Input[1] )

			local Inputs = table.Copy( Operator.Input )
			local Signature = string.format( "%s.%s(%s)", EXPADV.TypeName( table.remove( Inputs, 1 ) ), Operator.Name, NamePerams( Inputs, Operator.InputCount, Operator.UsesVarg ) )
				
			ClassPage:GetMethodSheet( ):AddLine( GetAvalibility(Operator), EXPADV.TypeName( Operator.Return or "" ) or "Void", Signature, Operator.Description )	
			BrowserSheet:GetMethodSheet( ):AddLine( GetAvalibility(Operator), EXPADV.TypeName( Operator.Return or "" ) or "Void", Signature, Operator.Description )	
		
			if Operator.Component then
				local Page = GetComponentPanel( Operator.Component )
				Page:GetMethodSheet( ):AddLine( GetAvalibility(Operator), EXPADV.TypeName( Operator.Return or "" ) or "Void", Signature, Operator.Description )	
			end
		end

	-- EVENTS:

		for _, Event in pairs( EXPADV.Events ) do
			local Page = GetComponentPanel( Event.Component )

			local Signature = string.format( "%s(%s)", Event.Name, NamePerams( Event.Input, Event.InputCount, false ) )
						
			Page:GetEventSheet( ):AddLine( GetAvalibility(Event), EXPADV.TypeName( Event.Return or "" ) or "Void", Signature, Event.Description or "N/A" )		
			BrowserSheet:GetEventSheet( ):AddLine( GetAvalibility(Event), EXPADV.TypeName( Event.Return or "" ) or "Void", Signature, Event.Description or "N/A" )		
		end

	-- CLASSES:

		local RootClassNode = NodeList:AddNode( "Classes" )
		RootClassNode:SetIcon( "fugue/rocket-fly.png" )

		for Short, Panel in pairs( ClassPanels ) do

			local Class = EXPADV.GetClass(Short)
			local Page = GetClassPanel( Short )

			if !Class or !Page then
				continue
			end

			Page:GetInfoSheet( ):AddLine( "Class", Class.Name )
			Page:GetInfoSheet( ):AddLine( "Extends", Class.DerivedClass and Class.DerivedClass.Name or "generic" ) 
			Page:GetInfoSheet( ):AddLine( "Component", Class.Component and Class.Component.Name or "Core" )
			Page:GetInfoSheet( ):AddLine( "Avalibility", GetAvalibility( Class ) )

			local ComponentNode = GetComponentNode( Class.Component, true )

			if !ComponentNode.ClassNode then
				ComponentNode.ClassNode = ComponentNode:AddNode( "Classes" )
				ComponentNode.ClassNode:SetIcon( "fugue/rocket-fly.png" )
			end

			local Node = ComponentNode.ClassNode:AddNode( Class.Name )
			Node:SetIcon( "fugue/block.png" )

			function Node:DoClick( )
				SetActiveClassPage( Short )
			end

			local Node = RootClassNode:AddNode( Class.Name )
			Node:SetIcon( "fugue/block.png" )

			function Node:DoClick( )
				SetActiveClassPage( Short )
			end
		end

	-- Search
		local SearchBox = vgui.Create( "DTextEntry", TabSheet )
		SearchBox:SetWide( 150 )
		SearchBox:SetValue( "Search..." )
		SearchBox:DockMargin( 2, 2, 2, 2 )
		SearchBox:Dock( BOTTOM )

		function SearchBox:OnGetFocus( )
			if self:GetValue() == "Search..." then
				self:SetValue( "" )
			end

			hook.Run( "OnTextEntryGetFocus", self )
		end

		function SearchBox:OnLoseFocus()
			if self:GetValue() == "" then
				timer.Simple( 0, function( )
					self:SetValue( "Search..." )
				end )
			end

			hook.Call( "OnTextEntryLoseFocus", nil, self )
		end

		
		local ClearSearch = vgui.Create( "DImageButton", SearchBox )
		ClearSearch:SetMaterial( "fugue/cross-button.png" )
		ClearSearch:DockMargin( 2,2,4,2 )
		ClearSearch:Dock( RIGHT )
		ClearSearch:SetSize( 14, 10 )
		ClearSearch:SetVisible( false )

		function ClearSearch:DoClick( )
			SearchBox:SetValue( "" )
			SearchBox:OnTextChanged( )
			SearchBox:SetValue( "Search..." )
		end

		function SearchBox:OnTextChanged( )
			SearchQuery = string.lower( self:GetValue( ) )

			ClearSearch:SetVisible( SearchQuery ~= "" )

			BrowserSheet:Search( SearchQuery )

			if IsValid( Frame.ActivePage ) then
				Frame.ActivePage:Search( SearchQuery )
			end
		end
end

hook.Add( "Expadv.AddMenuTabs", "expadv.manual", EXPADV.AddHelperTab )