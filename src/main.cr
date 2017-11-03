require "./init"
lib Main
    struct GPIO_InitTypeDef
        pin : UInt32
        mode : UInt32
        pull : UInt32
        speed : UInt32
        alternate : UInt32
    end

    struct GPIO_TypeDef
        moder : UInt32
        otyper : UInt32
        ospeedr : UInt32
        pupdr : UInt32
        idr : UInt32
        odr : UInt32
        bsrr : UInt32
        lckr : UInt32
        afr : Pointer(UInt32)
    end

    GPIO_MODE_OUTPUT_PP = 0x00000001u32
    GPIO_PULLUP = 0x00000001u32
    GPIO_SPEED_FREQ_VERY_HIGH = 0x00000003u32
    GPIO_PIN_0 = 0x0001u16

    PERIPH_BASE = 0x40000000u32
    APB1PERIPH_BASE = PERIPH_BASE
    APB2PERIPH_BASE = (PERIPH_BASE + 0x00010000u32)
    AHB1PERIPH_BASE = (PERIPH_BASE + 0x00020000u32)
    
    GPIOB_BASE = AHB1PERIPH_BASE + 0x0400u32
    GPIOB  = Pointer(GPIO_TypeDef).new(GPIOB_BASE.to_u64)
    
    fun hal_rcc_gpiob_clk_enable = a
    fun hal_gpio_init = HAL_GPIO_Init(gpiox : Pointer(GPIO_TypeDef), gpio_init : Pointer(GPIO_InitTypeDef))
    fun hal_gpio_toggle_pin = HAL_GPIO_TogglePin(gpiox : Pointer(GPIO_TypeDef), gpio_pin : UInt16)
    fun hal_delay = HAL_Delay(delay : UInt32)
end

Main.hal_rcc_gpiob_clk_enable

gpio = Main::GPIO_InitTypeDef.new

gpio.mode = Main::GPIO_MODE_OUTPUT_PP
gpio.pull = Main::GPIO_PULLUP
gpio.speed = Main::GPIO_SPEED_FREQ_VERY_HIGH
gpio.pin = Main::GPIO_PIN_0

Main.hal_gpio_init(Main::GPIOB, pointerof(gpio))

while true
    Main.hal_gpio_toggle_pin(Main::GPIOB, Main::GPIO_PIN_0)

    Main.hal_delay(50)
end