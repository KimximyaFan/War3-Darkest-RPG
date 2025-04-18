library EquipNameAndImg

function Set_Helmet_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 마스크" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNSobiMask.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "부두 마스크" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNHelmOfValor.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "히어로 헬름" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNHelmutPurple.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "데스 마스크" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNMaskOfDeath.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "데스로드 헬름" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNRevenant.blp" )
    endif
endfunction

function Set_Weapon_Name_and_Img takes Equip E returns nothing
    if E.Get_AD() > 0 then
        if E.Get_Grade() == 0 then
            call E.Set_Name( "병신 검" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp" )
        elseif E.Get_Grade() == 1 then
            call E.Set_Name( "푸른 검" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp" )
        elseif E.Get_Grade() == 2 then
            call E.Set_Name( "푸른 대검" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNThoriumRanged.blp" )
        elseif E.Get_Grade() == 3 then
            call E.Set_Name( "불의 검" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp" )
        elseif E.Get_Grade() == 4 then
            call E.Set_Name( "불의 대검" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNArcaniteRanged.blp" )
        endif
    else
        if E.Get_Grade() == 0 then
            call E.Set_Name( "병신 완드" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNStarWand.blp" )
        elseif E.Get_Grade() == 1 then
            call E.Set_Name( "주술 지팡이" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNWandSkull.blp" )
        elseif E.Get_Grade() == 2 then
            call E.Set_Name( "푸른 완드" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNWandOfManaSteal.blp" )
        elseif E.Get_Grade() == 3 then
            call E.Set_Name( "현자의 지팡이" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNAdvancedStrengthOfTheMoon.blp" )
        elseif E.Get_Grade() == 4 then
            call E.Set_Name( "달의 지팡이" )
            call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp" )
        endif
    endif
endfunction

function Set_Armor_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNLeatherUpgradeTwo.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "가죽 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNLeatherUpgradeOne.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "철 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNMoonArmor.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "판금 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNImprovedMoonArmor.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "달의 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNAdvancedMoonArmor.blp" )
    endif
endfunction

function Set_Shield_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNSteelArmor.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "철 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpOne.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "강철 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpTwo.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "불의 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "죽음의 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNAdvancedUnholyArmor.blp" )
    endif
endfunction

function Set_Necklace_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNNecklace.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "용기의 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNMedalionOfCourage.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "마법의 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNSpellShieldAmulet.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "금의 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNAmulet.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "달의 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNTalisman.blp" )
    endif
endfunction

function Set_Ring_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNRingVioletSpider.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "초록 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNCirclet.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "동 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNRingLionHead.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "은 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNRingSkull.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "황금 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNGoldRing.blp" )
    endif
endfunction

function Set_Belt_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 " + E.Integer_To_Type() )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNBelt.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "구린 " + E.Integer_To_Type() )
        call E.Set_Img( "BTN_Belt_Uncommon.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "그냥 " + E.Integer_To_Type() )
        call E.Set_Img( "BTN_Belt_Legend.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "좋은 " + E.Integer_To_Type() )
        call E.Set_Img( "BTN_Belt_Rare.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "짱좋은 " + E.Integer_To_Type() )
        call E.Set_Img( "BTN_Belt_Epic.blp" )
    endif
endfunction

function Set_Glove_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 장갑" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNUnholyStrength.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "평범한 장갑" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNGlove.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "마법의 장갑" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNSpellSteal.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "강력한 건틀릿" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNGauntletsOfOgrePower.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "불의 건틀릿" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNAdvancedUnholyStrength.blp" )
    endif
endfunction

function Set_Boots_Name_and_Img takes Equip E returns nothing
    if E.Get_Grade() == 0 then
        call E.Set_Name( "병신 부츠" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp" )
    elseif E.Get_Grade() == 1 then
        call E.Set_Name( "속도 부츠" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNBootsOfSpeed.blp" )
    elseif E.Get_Grade() == 2 then
        call E.Set_Name( "향상된 부츠" )
        call E.Set_Img( "ReplaceableTextures\\CommandButtons\\BTNBoots.blp" )
    elseif E.Get_Grade() == 3 then
        call E.Set_Name( "좋은 부츠" )
        call E.Set_Img( "BTN_Boots_Legend.blp" )
    elseif E.Get_Grade() == 4 then
        call E.Set_Name( "짱좋은 부츠" )
        call E.Set_Img( "BTN_Boots_Epic.blp" )
    endif
endfunction

endlibrary