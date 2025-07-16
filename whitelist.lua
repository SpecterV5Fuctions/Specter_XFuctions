return {
    --// WHITELIST GERAL (usuários que podem usar o script normalmente)
    whitelist = {
        [111111111] = true, -- member
        [222222222] = true, -- member
    },

    --// WHITELIST ADMIN (pode usar comandos como kick, mas não pode kickar o owner)
    whitelistAdmin = {
        [333333333] = true, -- admin
    },

    --// WHITELIST OWNER (poder total)
    whitelistOwner = {
        [8936659052] = true, -- owner
    },

    --// BLACKLIST (jogadores que são expulsos automaticamente)
    blacklist = {
        [444444444] = true, -- banido
    }
}
