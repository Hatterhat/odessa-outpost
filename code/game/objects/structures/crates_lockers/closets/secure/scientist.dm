/obj/structure/closet/secure_closet/personal/scientist
	name = "moebius scientist's locker"
	req_access = list(access_rd)
	access_occupy = list(access_tox_storage)
	icon_state = "science"

/obj/structure/closet/secure_closet/personal/scientist/populate_contents()
	new /obj/item/clothing/under/rank/scientist(src)
	//new /obj/item/clothing/suit/labcoat/science(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/weapon/cartridge/signal/science(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/weapon/tank/air(src)
	new /obj/item/clothing/mask/gas(src)

/obj/structure/closet/secure_closet/reinforced/RD
	name = "Moebius Expedition Overseer locker"
	req_access = list(access_rd)
	icon_state = "rd"

/obj/structure/closet/secure_closet/reinforced/RD/populate_contents()
	new /obj/item/clothing/suit/bio_suit/scientist(src)
	new /obj/item/clothing/head/bio_hood/scientist(src)
	new /obj/item/clothing/under/rank/expedition_overseer(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/weapon/cartridge/rd(src)
	new /obj/item/clothing/shoes/color(src)
	new /obj/item/clothing/shoes/leather(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/device/radio/headset/heads/rd(src)
	new /obj/item/weapon/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/flash(src)
