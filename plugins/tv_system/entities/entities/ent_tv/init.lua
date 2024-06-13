include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel(Model( "models/sonysmarttv42inch/sonysmarttv42inch.mdl" ))
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then
		physObj:EnableMotion(false);
		physObj:Sleep();
	end;

	-- See shared.lua
	-- Sets the default channel for this TV;
	self:SetChannel( next(ix.tv.channel.instances) or 0 )

	-- See shared.lua
	-- Turns off this TV;
	self:SetTurned( false );

    self:RegisterButtons()

	-- Turn on/off button;
	self.buttons[1].OnUse = function( entity )
		self:SetTurned( not self:GetTurned() )

		self:EmitSound("buttons/button18.wav")
	end;

	-- Previous channel;
	self.buttons[2].OnUse = function( entity )
		if not self:GetTurned() then return end;

		if self:GetChannel() == 0 then 
			self:EmitSound("buttons/combine_button_locked.wav")
			return 
		end;

		local channels = ix.tv.channel.instances;
		local prevID = 0;
		local nextID = 0;
		for k, v in pairs( channels ) do
			prevID = k;
			nextID = next( channels, k );

			if not nextID or (nextID and nextID == self:GetChannel()) then
				break;
			end;
		end;

		self:SetChannel( prevID )

		self:EmitSound("buttons/button18.wav")
	end;

	-- Next channel;
	self.buttons[3].OnUse = function( entity )
		if not self:GetTurned() then return end;

		if self:GetChannel() == 0 then 
			self:EmitSound("buttons/combine_button_locked.wav")
			return;
		end;

		local channels = ix.tv.channel.instances;

		if not next( channels, self:GetChannel() ) then
			self:SetChannel( next( channels ) )
		else
			self:SetChannel( next( channels, self:GetChannel() ) )
		end;

		self:EmitSound("buttons/button18.wav")
	end;

	local uniqueID = "ix.timer.channel.check" .. self:EntIndex();
	timer.Create(uniqueID, 1, 0, function()
		if (not IsValid( self )) then
			timer.Remove(uniqueID)
			return;
		end;

		local channel = self:GetChannel();
		local newChannel = next(ix.tv.channel.instances);
		local findChannel = ix.tv.channel.instances[ channel ]
		self:SetChannel( (findChannel and channel) or newChannel or 0 )
	end)

	if not self.tvID then
		ix.tv.id = ix.tv.id + 1;
		self.tvID = ix.tv.id;
	end;

	ix.tv.instances[self.tvID] = self;
end;

-- Touch prevent from using a TV as barricade.
-- Player still can leave when he is in tv, but on connect he'll stuck in it so admin can see the bug use attempt.
-- On the player will ragdoll himself until he lefts collision box, but this will trigger the Touch hook.
function ENT:Touch( toucher )
	if toucher and toucher ~= game.GetWorld() then
		self:SetCollisionGroup( 10 )
		timer.Create("ix.tv.touch" .. self:EntIndex(), 1, 0, function()
			if not self:IsValid() or not toucher or toucher == NULL then
				timer.Remove("ix.tv.touch" .. self:EntIndex())
				return;
			end;

			self:SetCollisionGroup( self:GetPos():DistToSqr( toucher:GetPos() ) < 3510 and 10 or 8 )
		end)
	end;
end;

function ENT:Use(client)
	if self:GetOwnerID() == client:GetCharacter():GetID() and client:KeyDown( IN_SPEED ) then
		net.Start("ix.tv.transporting.start")
		net.Send(client)

		-- Serverside pointer to this entity;
		client:SetLocalVar("furniture", self)
		-- Making entity uncollidable to prevent tool gun while transporting or using.
		self:SetCollisionGroup(10)
		return;
	end;

	local button = self:FindButton(client);

	if button then
		self.buttons[ button ].OnUse( self )
	end;
end;