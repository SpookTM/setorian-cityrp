local PLUGIN = PLUGIN
AddCSLuaFile()

SWEP.PrintName = "Nokia" -- change the name
SWEP.Author = "JohnyReaper"

SWEP.Category = "Setorian Miscellaneous" -- change the name

SWEP.Slot = 1
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/freeman/fbikid_c_nokia.mdl" ) -- just change the model 
SWEP.WorldModel = ( "models/freeman/fbikid_w_nokia.mdl" )
SWEP.ViewModelFOV = 85
SWEP.UseHands = true

SWEP.DrawCrosshair = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"

SWEP.Secondary.Ammo = "none"

SWEP.IsAlwaysLowered = true
SWEP.FireWhenLowered = true

SWEP.LowerAngles = Angle(0, 0, 0)
SWEP.LowerAngles2 = Angle(0, 0, 0)

SWEP.HoldType = "normal"

function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "MenuType" )
	self:NetworkVar( "Int", 1, "SelectedContact" )
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.Called = false
    return true
end

function SWEP:Deploy()

	if (IsFirstTimePredicted()) then

		self:SetMenuType(0)
		self:SetSelectedContact(1)
		

	self:CallOnClient("Deploy")

	end

	self.Called = false

end

function SWEP:ChangeContact(nextContact)

	if (self:GetSelectedContact() + nextContact > #PLUGIN.Dealers) then
		self:SetSelectedContact(1)
	elseif (self:GetSelectedContact() + nextContact <= 0) then
		self:SetSelectedContact(#PLUGIN.Dealers)
	else
		self:SetSelectedContact(self:GetSelectedContact() + nextContact)
	end

end

function SWEP:PrimaryAttack()

	if (IsFirstTimePredicted()) then

		if (self:GetNextPrimaryFire() > CurTime()) then return end

		if (CLIENT) then

			LocalPlayer():EmitSound("buttons/button15.wav")

		end

		self:GetOwner():LagCompensation( true )

		if (self:GetMenuType() == 1) then
			self:SetMenuType(2)

			if (self.Owner.DealerCalled) then
				if (SERVER) then
		            self.Owner:Notify("You've already called the dealer.")
		        end
	            self:SetMenuType(1)
	        end

			timer.Simple(1, function()
				if (!self) or (!IsValid(self)) then return end
				if (!self.Owner) or (!IsValid(self.Owner)) then return end
				if (self:GetMenuType() != 2) then return end

				if ((PLUGIN.Dealers[self:GetSelectedContact()].CoolDown or 0) < CurTime()) then

					self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_1 )

					if (SERVER) then
						PLUGIN:DealerCalled(self.Owner,self:GetSelectedContact())
					end
					self:SetMenuType(3)
					self.Called = true

				else
					self:SetMenuType(1)
					if (SERVER) then
						self.Owner:Notify("The number does not answer. Try again later")
					end
				end

			end)

		elseif (self:GetMenuType() == 0) then
			self:SetMenuType(1)
		end

		self:GetOwner():LagCompensation( false )

		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.5 )

	end
	
end 

function SWEP:SecondaryAttack()

	if (IsFirstTimePredicted()) then

		if (self:GetNextSecondaryFire() > CurTime()) then return end

		if (CLIENT) then

			LocalPlayer():EmitSound("buttons/button15.wav")

		end

		self:GetOwner():LagCompensation( true )

		local ply = self.Owner

		if (self:GetMenuType() == 2) then
			if (!self.Called) then
				self:SetMenuType(1)
			end
		elseif (self:GetMenuType() == 1) then
			self:ChangeContact( (ply:KeyDown( IN_USE ) and -1) or 1 )
		elseif (self:GetMenuType() == 0) then
			self:SetMenuType(1)
		end

		self:GetOwner():LagCompensation( false )

		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:SetNextSecondaryFire( CurTime() + 0.5 )

	end
	
end

function SWEP:Reload()
	return true
end

if (CLIENT) then

	local PLUGIN = PLUGIN

	local bg_color = Color(19, 104, 56)
	local color_semi_white = Color(200,200,200)
	local color_outline = Color(20,20,20)

	local mouse_lmb = ix.util.GetMaterial("gui/lmb.png")
	local mouse_rmb = ix.util.GetMaterial("gui/rmb.png")
	local e_key = ix.util.GetMaterial("gui/e.png")

	local w, h = 70, 54

	local menus = {
		[1] = function(self)
			self:DrawContacts()
		end,
		[2] = function(self)
			self:DrawCalling()
		end,
	}

	// https://github.com/Facepunch/garrysmod/blob/fabb02a0dc8a2073461bda4d1336435314ac7ea6/garrysmod/gamemodes/sandbox/entities/weapons/gmod_tool/cl_viewscreen.lua#L16
	local function DrawScrollingText( text, y, texwide )

		if (text == nil) then return end

		surface.SetFont("ixMonoSmallFont")
		local w, h = surface.GetTextSize( text )
		w = w + 64

		-- y = y - h / 2 -- Center text to y position

		local x = RealTime() * 50 % w * -1

		while ( x < texwide ) do

			surface.SetTextColor( color_semi_white )
			surface.SetTextPos( x, y )
			surface.DrawText( text )

			x = x + w

		end

	end

	function SWEP:DrawMainMenu()

		draw.SimpleText( "-", "ixIconsSmall", w/2, h/2 - 5, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		draw.SimpleText( "Contacts", "ixMonoSmallFont", w/2, h - 2, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

		-- draw.SimpleTextOutlined( "LMB", "ixSmallBoldFont", w/2, -80, Color(200,200,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20) )
		
		surface.SetDrawColor(color_black )
	    surface.SetMaterial( mouse_lmb )
		surface.DrawTexturedRect(-7,-82,20,20)

		surface.SetDrawColor(color_semi_white )
	    surface.SetMaterial( mouse_lmb )
		surface.DrawTexturedRect(-5,-80,16,16)

		draw.SimpleTextOutlined( "SELECT", "ixSmallBoldFont", w/2 + 13, -60, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_outline )


	end

	local dealerTypes = {
		"Weed", "Cocaine"
	}

	local menuPos = 1

	local contact_bg = Color(10, 94, 46)
	local contact_bg_select = Color(19, 74, 56)

	local offsetH = 0

	surface.CreateFont("BurnerPhone_Font1", {
		font = "Consolas",
		size = 16,
		extended = true,
		weight = 800
	})

	
	function SWEP:DrawContacts()
		
		local pageMath = (math.ceil(self:GetSelectedContact()/2)*2)
		local pageNumber = math.ceil(self:GetSelectedContact()/2)

		local maxPages = math.ceil(#PLUGIN.Dealers/2)

		local itemOffset = 0

		for i=pageMath-1, pageMath do

			if (!PLUGIN.Dealers[i]) then continue end

			surface.SetDrawColor( (self:GetSelectedContact() == i and contact_bg_select) or contact_bg)
			surface.DrawRect( 1, 2 + itemOffset , w-2, 15 )

			local dealerType = PLUGIN.Dealers[i].DealerType
			local dealerTypeName

			if (istable(dealerType)) then
				-- dealerTypeName = table.concat( ix.item.list[dealerType].name, "|" )

				local niceString = ""

				for k,v in ipairs(dealerType) do
					niceString = niceString .. ix.item.list[v].name .."|" 
				end

				dealerTypeName = string.TrimRight(niceString, "|")

			else
				dealerTypeName = ix.item.list[dealerType].name
			end

			clipping_handler.clip:Scissor2D(w-4, h)

			if (self:GetSelectedContact() == i) then
				DrawScrollingText( PLUGIN.Dealers[i].DealerName .." ["..dealerTypeName.."]", 3 + itemOffset, 70 )
			else
				draw.SimpleText( PLUGIN.Dealers[i].DealerName .." ["..dealerTypeName.."]", "ixMonoSmallFont", 5, 3 + itemOffset, color_semi_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			clipping_handler.clip()

			itemOffset = itemOffset + 17

		end

		draw.SimpleText( "Page "..pageNumber.."/"..maxPages, "ixMonoSmallFont", w/2, h-4, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )


		surface.SetDrawColor(color_black )
	    surface.SetMaterial( mouse_lmb )
		surface.DrawTexturedRect(0,-122,20,20)
		surface.SetDrawColor(color_semi_white )
	    surface.SetMaterial( mouse_lmb )
		surface.DrawTexturedRect(2,-120,16,16)
		draw.SimpleTextOutlined( "SELECT", "ixSmallBoldFont", w/2 + 18, -100, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_outline )
		
		surface.SetDrawColor(color_black )
	    surface.SetMaterial( mouse_rmb )
		surface.DrawTexturedRect(0,-99,20,20)
		surface.SetDrawColor(color_semi_white )
	    surface.SetMaterial( mouse_rmb )
		surface.DrawTexturedRect(2,-97,16,16)

		-- draw.SimpleTextOutlined( "r", "ixIconsMedium", w/2, -75, Color(200,200,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(20,20,20) )
		
		surface.SetDrawColor(color_black )
	    surface.SetMaterial( mouse_rmb )
		surface.DrawTexturedRect(56,-99,20,20)
		surface.SetDrawColor(color_semi_white )
	    surface.SetMaterial( mouse_rmb )
		surface.DrawTexturedRect(58,-97,16,16)

		surface.SetDrawColor(color_black )
	    surface.SetMaterial( e_key )
		surface.DrawTexturedRect(41,-98,18,18)
		surface.SetDrawColor(color_semi_white )
	    surface.SetMaterial( e_key )
		surface.DrawTexturedRect(42,-97,16,16)

		draw.SimpleTextOutlined( "r     u", "ixIconsMedium", w/2, -56, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_outline )


		-- surface.SetDrawColor( contact_bg )
		-- surface.DrawRect( 1, 19, w-2, 15 )

		-- surface.SetDrawColor( contact_bg )
		-- surface.DrawRect( 1, 37, w-2, 15 )

	end

	function SWEP:DrawCalling()

		-- clipping_handler.clip:Scissor2D(w-4, h)
		-- DrawScrollingText( self.test[self:GetSelectedContact()].DealerName, h*0.35, 70 )

		local dealerName = PLUGIN.Dealers[self:GetSelectedContact()].DealerName

		if (#dealerName > 13) then
			draw.SimpleText( dealerName:utf8sub(1, 10).."_", "ixMonoSmallFont", w/2, h*0.35, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( dealerName, "ixMonoSmallFont", w/2, h*0.35, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		-- clipping_handler.clip()

		draw.SimpleText( "Calling...", "ixMonoSmallFont", w/2, h - 5, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )


		surface.SetDrawColor(color_black )
	    surface.SetMaterial( mouse_rmb )
		surface.DrawTexturedRect(-7,-82,20,20)
		surface.SetDrawColor(color_semi_white )
	    surface.SetMaterial( mouse_rmb )
		surface.DrawTexturedRect(-5,-80,16,16)

		draw.SimpleTextOutlined( "CANCEL", "ixSmallBoldFont", w/2 + 13, -60, color_semi_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_outline )



	end

	function SWEP:ViewModelDrawn(vm)

		if (self:GetMenuType() != 3) then
			local Ang = vm:GetAngles()
			local Pos = vm:GetPos()

			Ang:RotateAroundAxis(Ang:Up(), -90)
			Ang:RotateAroundAxis(Ang:Forward(), 86)
			Ang:RotateAroundAxis(Ang:Right(), 10)

			cam.Start3D2D( Pos + Ang:Up() * -13.41 + Ang:Forward() * 2.56 + Ang:Right() * 0.61, Ang, 0.025 )

				surface.SetDrawColor( bg_color )
				surface.DrawRect( 0, 0, w, h )

				if (self:GetMenuType() == 0) then
					self:DrawMainMenu()
				else
					menus[self:GetMenuType()](self)
				end
			
							
			cam.End3D2D()

		end

	end

end