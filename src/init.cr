require "crystal/main"


lib Main
    fun sys_init(speed : Int32)
    fun hal_init = HAL_Init
    fun system_clock_config = SystemClock_Config
end

module Crystal
    def self.main(argc : Int32, argv : UInt8**): Int32
        Main.hal_init
        Main.system_clock_config

        main_user_code(argc, argv)

        0
        # Main.sys_init 500
        # 0
    end
end