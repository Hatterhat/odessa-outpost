/datum/breakdown/positive
	start_message_span = "bold notice"
	icon_state = "positive"

/datum/breakdown/negative
	start_message_span = "danger"
	restore_sanity_pre = 25
	icon_state = "negative"

/datum/breakdown/common
	start_message_span = "danger"
	restore_sanity_pre = 25
	icon_state = "negative"



#define STALWART_THRESHOLD 30 // How damaged should owner be for Stalwart to be able to trigger

/datum/breakdown/positive/stalwart
	name = "Stalwart"
	duration = 0
	restore_sanity_post = 100

	start_messages = list(
		"You feel like pain is the key to greatness!",
		"You feel like you can survive even the worst hell!",
		"You feel like you can endure the worst pain!",
		"You feel like pain has shredded your mortal cloth!",
		"You feel like pain has cleared your mind!"
	)

/datum/breakdown/positive/stalwart/can_occur()
	return holder.owner.maxHealth - holder.owner.health > STALWART_THRESHOLD

/datum/breakdown/positive/stalwart/conclude()
	holder.owner.adjustBruteLoss(-15)
	holder.owner.adjustCloneLoss(-5)
	holder.owner.adjustFireLoss(-15)
	holder.owner.adjustOxyLoss(-25)
	holder.owner.adjustToxLoss(-15)
	holder.owner.reagents.add_reagent("tramadol", 5)
	..()



/datum/breakdown/positive/adaptation
	name = "Adaptation"
	duration = 0
	restore_sanity_post = 100

	start_messages = list(
		"You feel your inner mind becoming hardened by your adventures!",
		"You feel like you can still relax despite the problems around you!",
		"You feel like your mistakes are the path to enlightenment!",
		"You feel like you can adapt to any difficulty faced!",
		"You feel like you have the upper hand in any situation!"
	)

/datum/breakdown/positive/adaptation/conclude()
	holder.positive_prob = min(holder.positive_prob + 10, 100)
	holder.negative_prob = max(holder.negative_prob - 5, 0)
	holder.max_level = max(holder.max_level + 20, 0)
	..()



/datum/breakdown/positive/concentration
	name = "Absolute Concentration"
	duration = 20 MINUTES

	start_messages = list(
		"You feel like your mind is concentrated beyond normal capabilities!",
		"You feel like you can mentally endure whatever happens!",
		"You feel like the darkest corners of your mind are enlightened by your will!",
		"You feel like no obstacle is a match for you!",
		"You feel like you have shone a light into the abyss with your will!"
	)

/datum/breakdown/positive/concentration/New()
	..()
	restore_sanity_pre = holder.max_level

/datum/breakdown/positive/concentration/occur()
	++holder.sanity_invulnerability
	return ..()

/datum/breakdown/positive/concentration/conclude()
	--holder.sanity_invulnerability
	..()



/datum/breakdown/positive/determination
	name = "Determination"
	duration = 10 MINUTES
	restore_sanity_pre = 100

	start_messages = list(
		"You're filled with determination!",
		"You feel like nothing can stand against you!",
		"You feel that you will endure whatever you face!",
		"You feel your determination shaping your body to its prime!",
		"You feel immortality in your veins!"
	)
	end_messages = list(
		"Your determination wears off. Will you feel this ever again?"
	)

/datum/breakdown/positive/determination/occur()
	++holder.owner.shock_resist
	return ..()

/datum/breakdown/positive/determination/conclude()
	--holder.owner.shock_resist
	..()



/datum/breakdown/positive/lesson
	name = "A Lesson Learnt"
	duration = 0
	restore_sanity_post = 100

	start_messages = list(
		"You feel like your mistakes have shaped you for the better!",
		"You feel like you have learnt from the past!",
		"You feel how your past taught you great lessons!",
		"You feel far greater clarity in your senses!",
		"You feel past knowledge pouring into your brain!"
	)

/datum/breakdown/positive/lesson/conclude()
	for(var/stat in ALL_STATS)
		holder.owner.stats.changeStat(stat, rand(5,10))
	..()



/datum/breakdown/negative/selfharm
	name = "Self-harm"
	duration = 1 MINUTES
	restore_sanity_post = 70

	start_messages = list(
		"You can't take this anymore!",
		"Your inner empire now reigns your body!",
		"You mind is no more. Instincts are all you have now!",
		"You can't live like this, your mind begs for mercy!",
		"You feel like you aren't yourself right now!"
	)
	end_messages = list(
		"You feel easier now, with a body back at your control."
	)

/datum/breakdown/negative/selfharm/update()
	. = ..()
	if(!.)
		return
	var/datum/gender/G = holder.owner.get_gender()
	if(prob(50))
		var/emote = pick(list(
			"screams in a devilish voice!",
			"bites [G.his] tongue in an attempt to scream!",
			"screams muffled bigotry in a otherworldly voice!",
			"laughs in a devilish voice!",
			"laughs with muffled agony!",
			"laughs uncontrollably!",
			"laughs and twitches at the same time!"
		))
		holder.owner.custom_emote(message=emote)
	else if(!holder.owner.incapacitated())
		var/obj/item/W = holder.owner.get_active_hand()
		if(W)
			W.attack(holder.owner, holder.owner, ran_zone())
		else
			var/damage_eyes = prob(40)
			if(damage_eyes)
				for(var/obj/item/protection in list(holder.owner.head, holder.owner.wear_mask, holder.owner.glasses))
					if(protection && (protection.body_parts_covered & EYES))
						damage_eyes = FALSE
						break
			if(damage_eyes)
				holder.owner.visible_message(SPAN_DANGER("[holder.owner] scratches [G.his] eyes!"))
				var/obj/item/organ/internal/eyes/eyes = holder.owner.internal_organs_by_name[BP_EYES]
				eyes.take_damage(rand(1,2), 1)
			else
				holder.owner.visible_message(SPAN_DANGER(pick(list(
					"[holder.owner] tries to end [G.his] misery!",
					"[holder.owner] tried to peel [G.his] skin off!",
					"[holder.owner] bites [G.his] limbs uncontrollably!"
				))))
				var/list/obj/item/organ/external/parts = holder.owner.get_damageable_organs()
				if(parts.len)
					holder.owner.damage_through_armor(rand(2,4), def_zone = pick(parts))

/datum/breakdown/negative/selfharm/occur()
	++holder.owner.suppress_communication
	return ..()

/datum/breakdown/negative/selfharm/conclude()
	--holder.owner.suppress_communication
	..()



/datum/breakdown/negative/hysteric
	name = "Hysteric"
	duration = 2 MINUTES
	restore_sanity_post = 50

	start_messages = list(
		"You feel like your mind can't hold these emotions anymore!",
		"You feel terrible sorrow overwhelming you!",
		"You feel like there is no point in being yourself anymore!",
		"You feel like tears are pouring on your face!",
		"You feel like there is something inside you which can't be restrained!"
	)
	end_messages = list(
		"You feel better now."
	)

/datum/breakdown/negative/hysteric/update()
	. = ..()
	if(!.)
		return
	holder.owner.Weaken(3)
	holder.owner.Stun(3)
	if(prob(50))
		holder.owner.emote("scream")
	else
		holder.owner.emote("cry")

/datum/breakdown/negative/hysteric/occur()
	holder.owner.SetWeakened(4)
	holder.owner.SetStunned(4)
	++holder.owner.suppress_communication
	return ..()

/datum/breakdown/negative/hysteric/conclude()
	holder.owner.SetWeakened(0)
	holder.owner.SetStunned(0)
	--holder.owner.suppress_communication
	..()



/datum/breakdown/negative/delusion
	//name = "Delusion"
	duration = 5 MINUTES
	restore_sanity_post = 50

	start_messages = list(
		"You feel like something is speaking to you from within!",
		"You feel a voice starting to scream in your head!",
		"You feel like your brain decided to scream at you!",
		"You feel like voices marching in your mind!",
		"You feel sounds warp into cacophony!"
	)
	end_messages = list(
		"You feel silence, again."
	)

/datum/breakdown/negative/delusion/update()
	. = ..()
	if(!.)
		return
	if(prob(10))
		var/power = rand(9,27)
		holder.owner.playsound_local(holder.owner, 'sound/effects/explosionfar.ogg', 100, 1, round(power*2,1) )
		holder.owner.playsound_local(holder.owner, "explosion", 100, 1, round(power,1) )
		shake_camera(holder.owner, 2)
	if(prob(10))
		holder.owner.playsound_local(holder.owner, 'sound/effects/alert.ogg')



/datum/breakdown/negative/fabric
	name = "The Fabric"
	duration = 10 MINUTES
	var/list/image/images = list()

	start_messages = list(
		"You feel like you understand something that you shouldn't...",
		"You feel dark thoughts crawling through your head...",
		"You feel your mind trying to comprehend the secrets of the universe itself.",
		"You feel it. Secrets. They are all around you.",
		"You feel like your tower of knowledge is almost complete!"
	)
	end_messages = list(
		"You feel like it is gone. But would it return?"
	)

/datum/breakdown/negative/fabric/occur()
	RegisterSignal(SSdcs, COMSIG_GLOB_FABRIC_NEW, .proc/add_image)
	RegisterSignal(holder.owner, COMSIG_MOB_LOGIN, .proc/update_client_images)
	for(var/datum/component/fabric/F in GLOB.fabric_list)
		if(F.parent == holder.owner)
			continue
		add_image(null, F.fabric_image)
	++holder.owner.language_blackout
	return ..()

/datum/breakdown/negative/fabric/conclude()
	--holder.owner.language_blackout
	holder.owner.client?.images -= images
	UnregisterSignal(SSdcs, COMSIG_GLOB_FABRIC_NEW)
	UnregisterSignal(holder.owner, COMSIG_MOB_LOGIN)
	images.Cut()
	..()

/datum/breakdown/negative/fabric/proc/add_image(_, image/I)
	images |= I
	holder.owner.client?.images |= I

/datum/breakdown/negative/fabric/proc/update_client_images()
	holder.owner.client?.images |= images



/datum/breakdown/negative/spiral
	name = "Downward-spiral"
	duration = 0
	restore_sanity_post = 50

	start_messages = list(
		"You feel like there is no point in any of this!",
		"You brain refuses to comprehend any of this!",
		"You feel like you don't want to continue!",
		"You feel like your best days are forever behind you!",
		"You feel it. You know it. There is no turning back!"
	)

/datum/breakdown/negative/spiral/conclude()
	holder.positive_prob = max(holder.positive_prob - 10, 0)
	holder.negative_prob = min(holder.negative_prob + 20, 100)
	holder.max_level = max(holder.max_level - 20, 0)
	..()



/datum/breakdown/common/obsession
	name = "Obsession"
	var/obj/item/target
	var/objectname

	start_messages = list(
		"You hear a sickening, raspy voice in your head. It wants one small task of you...",
		"Your mind is impaled with the sickening need to hold something...",
		"Your mind whispers a secret to you, but you need a token to access its treasures...",
		"You feel like the key to true power is before you...",
		"You feel under constant pressure, but there a way to ease the pain..."
	)
	end_messages = list(
		"You feel easier again, at once."
	)

/datum/breakdown/common/obsession/New()
	..()
	if(prob(97))
		var/list/candidates = list() //subtypesof(/obj/item/weapon/oddity)
		while(candidates.len)
			target = pick(candidates)
			if(!locate(target))
				candidates -= target
				target = null
				continue
			objectname = initial(target.name)
			break
	if(!target)
		var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - holder.owner
		if(candidates.len)
			var/mob/living/carbon/human/H = pick(candidates)
			target = pick(H.organs - H.organs_by_name[BP_CHEST])
			objectname = "[H.real_name]'s [target.name]"

/datum/breakdown/common/obsession/can_occur()
	return !!target

/datum/breakdown/common/obsession/update()
	. = ..()
	if(!.)
		return
	var/obj/item/found = FALSE
	if(ispath(target))
		found = locate(target) in holder.owner
	else
		if(QDELETED(target))
			conclude()
			return FALSE
		found = target.loc == holder.owner
	if(found)
		var/message = pick(list(
			"Your mind convulses in the ecstasy. The sacred is now yours!",
			"You feel warmth of the [objectname] in your head.",
			"You suffered so long to achieve greatness! The sacred [objectname] is now yours. Only yours."
		))
		to_chat(holder.owner, SPAN_NOTICE(message))
		holder.restoreLevel(70)
		conclude()
		return FALSE
	if(prob(50))
		var/message = pick(list(
			"You knew it. The [objectname] will ease your journey to the stars.",
			"You watch, but the only thing you can see is [objectname].",
			"Your thoughts are all about [objectname].",
			"You imagine how you will pour your hands into still warm [objectname].",
			"Vivid imagery of [objectname] is all around your brain.",
			"You know it. It is the key to your salvation. [capitalize(objectname)]. [capitalize(objectname)]. [capitalize(objectname)]!",
			"Thin voice within says only one thing: [objectname].",
			"It hurts you to keep pretending that your life without [objectname] have meaning.",
			"Your minds whispers to you with the only words in their silent throats: [objectname].",
			"You know that only salvation from your sins is [objectname]."
		))
		to_chat(holder.owner, SPAN_NOTICE(message))

/datum/breakdown/common/obsession/occur()
	for(var/stat in ALL_STATS)
		holder.owner.stats.addTempStat(stat, -5, INFINITY, "Obsession")
	return ..()

/datum/breakdown/common/obsession/conclude()
	for(var/stat in ALL_STATS)
		holder.owner.stats.removeTempStat(stat, "Obsession")
	..()



#define KLEPTOMANIA_COOLDOWN rand(30 SECONDS, 60 SECONDS)

/datum/breakdown/common/kleptomania
	name = "Kleptomania"
	duration = 20 MINUTES
	restore_sanity_post = 50
	var/pickup_time = 0

	start_messages = list(
		"You feel the need to hold something, that you perhaps shouldn't...",
		"You feel like others don't value what they have, but you on the other hand...",
		"You feel like everything should be in your possession...",
		"You feel like everything can be yours, with a bit of effort...",
		"You feel like some things are of great use to you, it won't hurt to take them..."
	)
	end_messages = list(
		"You feel much better about not stealing things now."
	)

/datum/breakdown/common/kleptomania/update()
	. = ..()
	if(!. || holder.owner.incapacitated())
		return
	if(world.time >= pickup_time)
		pickup_time = world.time + KLEPTOMANIA_COOLDOWN
		var/list/obj/item/candidates = oview(1, holder.owner)
		while(candidates.len)
			var/obj/item/I = pick(candidates)
			if(!istype(I) || I.anchored || !I.Adjacent(holder.owner) || !I.pre_pickup(holder.owner))
				candidates -= I
				continue
			if(!holder.owner.put_in_hands(I) && prob(50))
				holder.owner.unEquip(holder.owner.get_inactive_hand())
				holder.owner.put_in_hands(I)
			break



/datum/breakdown/common/signs
	//name = "Signs"
	restore_sanity_post = 70
	var/message

	start_messages = list(
		"You feel like the fabric of reality is visible to you...",
		"You feel that the truth is hidden somewhere, right in your mind...",
		"You feel like your mind have spoken to you, after centuries of silence...",
		"You feel like you were blind, but now you can see...",
		"You feel like the universe itself is speaking to you..."
	)
	end_messages = list(
		"The truth has spoken. You feel it again. The melody of sounds returns."
	)

/datum/breakdown/common/signs/New()
	..()
	message = "Etiam tempor orci eu lobortis elementum nibh tellus molestie"

/datum/breakdown/common/signs/update()
	. = ..()
	if(!.)
		return
	if(!prob(40))
		return
	var/list/words = splittext(message, " ")
	var/phrase_len = rand(1,2)
	var/phrase_pos = rand(1, words.len - phrase_len)
	to_chat(holder.owner,"...[jointext(words, " ", phrase_pos, phrase_pos + phrase_len + 1)]...")

/datum/breakdown/common/signs/occur()
	RegisterSignal(holder.owner, COMSIG_HUMAN_SAY, .proc/check_message)
	return ..()

/datum/breakdown/common/signs/conclude()
	UnregisterSignal(holder.owner, COMSIG_HUMAN_SAY)
	..()

/datum/breakdown/common/signs/proc/check_message(_, msg)
	if(msg == message)
		finished = TRUE



/datum/breakdown/common/ptsd
	name = "PTSD"
	duration = 10 MINUTES
	restore_sanity_post = 50

	start_messages = list(
		"You feel like you are constantly living on the edge...",
		"You feel much more focused on everything at once...",
		"You feel like everything is a danger, better be prepared...",
		"Your senses are much sharper than ever before, but at what price...",
		"You hear much better now, the cacophony of sounds is no more."
	)
	end_messages = list(
		"You feel like you waded into the quiet of the stream."
	)

/datum/breakdown/common/ptsd/occur()
	++holder.owner.flashbacks
	return ..()

/datum/breakdown/common/ptsd/conclude()
	--holder.owner.flashbacks
	..()
