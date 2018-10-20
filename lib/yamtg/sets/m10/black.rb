creature 'Black Knight' do
    cost        2.black
    type        :Human_Knight
    power       2
    toughness   2

    first_strike

    description 'Protection from white'
end

creature 'Child of Night' do
    cost        1.black, 1.colorless
    type        :Vampire
    power       2
    toughness   1

    lifelink

    legend  'A vampire enacts vengeance on the entire world, claiming her debt two tiny pinpricks at a time.'
end

creature 'Dread Warlock' do
    cost        2.black, 1.colorless
    type        :Human_Wizard
    power       2
    toughness   2

    description 'Dread Warlock can\'t be blocked except by black creatures'
end

creature 'Drudge Skeletons' do
    cost        1.black, 1.colorless
    type        :Skeleton
    power       1
    toughness   1

    description '{K}: Regenerate Drudge Skeletons'
end

sorcery 'Demon\'s Horn' do
    cost        2.colorless
    artifact
end

sorcery 'Duress' do
    cost        1.black
    description 'Target opponent reveals his or her hand...'
end
