    .thumb
    .syntax unified

    .section ._vector_table

    .word stack_start
    .word reset_handler
    .word nmi_handler
    .word hardfault_handler
    .word memmange_handler
    .word busfault_handler
    .word usagefault_handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word svc_handler
    .word debugmon_handler
    .word 0
    .word pendsv_handler
    .word systick_handler
# 外部硬件的中断 由厂商规定
    .word WWDG_IRQHandler            
    .word PVD_IRQHandler
    .word TAMPER_IRQHandler          
    .word RTC_IRQHandler             
    .word FLASH_IRQHandler           
    .word RCC_IRQHandler             
    .word EXTI0_IRQHandler           
    .word EXTI1_IRQHandler           
    .word EXTI2_IRQHandler           
    .word EXTI3_IRQHandler           
    .word EXTI4_IRQHandler           
    .word DMA1_Channel1_IRQHandler   
    .word DMA1_Channel2_IRQHandler   
    .word DMA1_Channel3_IRQHandler   
    .word DMA1_Channel4_IRQHandler   
    .word DMA1_Channel5_IRQHandler   
    .word DMA1_Channel6_IRQHandler   
    .word DMA1_Channel7_IRQHandler   
    .word ADC1_2_IRQHandler          
    .word USB_HP_CAN1_TX_IRQHandler   
    .word USB_LP_CAN1_RX0_IRQHandler 
    .word CAN1_RX1_IRQHandler        
    .word CAN1_SCE_IRQHandler        
    .word EXTI9_5_IRQHandler         
    .word TIM1_BRK_IRQHandler        
    .word TIM1_UP_IRQHandler         
    .word TIM1_TRG_COM_IRQHandler
    .word TIM1_CC_IRQHandler         
    .word TIM2_IRQHandler            
    .word TIM3_IRQHandler            
    .word TIM4_IRQHandler            
    .word I2C1_EV_IRQHandler         
    .word I2C1_ER_IRQHandler         
    .word I2C2_EV_IRQHandler         
    .word I2C2_ER_IRQHandler         
    .word SPI1_IRQHandler            
    .word SPI2_IRQHandler            
    .word USART1_IRQHandler          
    .word USART2_IRQHandler          
    .word USART3_IRQHandler          
    .word EXTI15_10_IRQHandler       
    .word RTCAlarm_IRQHandler
    .word USBWakeUp_IRQHandler       

    .section .text

    .type reset_handler, function
    .type nmi_handler, function
    .type hardfault_handler, function
    .type memmange_handler, function
    .type busfault_handler, function
    .type usagefault_handler, function
    .type svc_handler, function
    .type debugmon_handler, function
    .type pendsv_handler, function
    .type systick_handler, function
    .type WWDG_IRQHandler, function            
    .type PVD_IRQHandler, function
    .type TAMPER_IRQHandler, function          
    .type RTC_IRQHandler, function             
    .type FLASH_IRQHandler, function           
    .type RCC_IRQHandler, function             
    .type EXTI0_IRQHandler, function           
    .type EXTI1_IRQHandler, function           
    .type EXTI2_IRQHandler, function           
    .type EXTI3_IRQHandler, function           
    .type EXTI4_IRQHandler, function           
    .type DMA1_Channel1_IRQHandler, function   
    .type DMA1_Channel2_IRQHandler, function   
    .type DMA1_Channel3_IRQHandler, function   
    .type DMA1_Channel4_IRQHandler, function   
    .type DMA1_Channel5_IRQHandler, function   
    .type DMA1_Channel6_IRQHandler, function   
    .type DMA1_Channel7_IRQHandler, function   
    .type ADC1_2_IRQHandler, function          
    .type USB_HP_CAN1_TX_IRQHandler, function   
    .type USB_LP_CAN1_RX0_IRQHandler, function 
    .type CAN1_RX1_IRQHandler, function        
    .type CAN1_SCE_IRQHandler, function        
    .type EXTI9_5_IRQHandler, function         
    .type TIM1_BRK_IRQHandler, function        
    .type TIM1_UP_IRQHandler, function         
    .type TIM1_TRG_COM_IRQHandler, function
    .type TIM1_CC_IRQHandler, function         
    .type TIM2_IRQHandler, function            
    .type TIM3_IRQHandler, function            
    .type TIM4_IRQHandler, function            
    .type I2C1_EV_IRQHandler, function         
    .type I2C1_ER_IRQHandler, function         
    .type I2C2_EV_IRQHandler, function         
    .type I2C2_ER_IRQHandler, function         
    .type SPI1_IRQHandler, function            
    .type SPI2_IRQHandler, function            
    .type USART1_IRQHandler, function          
    .type USART2_IRQHandler, function          
    .type USART3_IRQHandler, function          
    .type EXTI15_10_IRQHandler, function       
    .type RTCAlarm_IRQHandler, function
    .type USBWakeUp_IRQHandler, function       

    .weak reset_handler
    .weak nmi_handler
    .weak hardfault_handler
    .weak memmange_handler
    .weak busfault_handler
    .weak usagefault_handler
    .weak svc_handler
    .weak debugmon_handler
    .weak pendsv_handler
    .weak systick_handler
    .weak WWDG_IRQHandler            
    .weak PVD_IRQHandler
    .weak TAMPER_IRQHandler          
    .weak RTC_IRQHandler             
    .weak FLASH_IRQHandler           
    .weak RCC_IRQHandler             
    .weak EXTI0_IRQHandler           
    .weak EXTI1_IRQHandler           
    .weak EXTI2_IRQHandler           
    .weak EXTI3_IRQHandler           
    .weak EXTI4_IRQHandler           
    .weak DMA1_Channel1_IRQHandler   
    .weak DMA1_Channel2_IRQHandler   
    .weak DMA1_Channel3_IRQHandler   
    .weak DMA1_Channel4_IRQHandler   
    .weak DMA1_Channel5_IRQHandler   
    .weak DMA1_Channel6_IRQHandler   
    .weak DMA1_Channel7_IRQHandler   
    .weak ADC1_2_IRQHandler          
    .weak USB_HP_CAN1_TX_IRQHandler   
    .weak USB_LP_CAN1_RX0_IRQHandler 
    .weak CAN1_RX1_IRQHandler        
    .weak CAN1_SCE_IRQHandler        
    .weak EXTI9_5_IRQHandler         
    .weak TIM1_BRK_IRQHandler        
    .weak TIM1_UP_IRQHandler         
    .weak TIM1_TRG_COM_IRQHandler
    .weak TIM1_CC_IRQHandler         
    .weak TIM2_IRQHandler            
    .weak TIM3_IRQHandler            
    .weak TIM4_IRQHandler            
    .weak I2C1_EV_IRQHandler         
    .weak I2C1_ER_IRQHandler         
    .weak I2C2_EV_IRQHandler         
    .weak I2C2_ER_IRQHandler         
    .weak SPI1_IRQHandler            
    .weak SPI2_IRQHandler            
    .weak USART1_IRQHandler          
    .weak USART2_IRQHandler          
    .weak USART3_IRQHandler          
    .weak EXTI15_10_IRQHandler       
    .weak RTCAlarm_IRQHandler
    .weak USBWakeUp_IRQHandler       

    reset_handler:
    nmi_handler:
    hardfault_handler:
    memmange_handler:
    busfault_handler:
    usagefault_handler:
    svc_handler:
    debugmon_handler:
    pendsv_handler:
    systick_handler:
    WWDG_IRQHandler:            
    PVD_IRQHandler:
    TAMPER_IRQHandler:          
    RTC_IRQHandler:             
    FLASH_IRQHandler:           
    RCC_IRQHandler:             
    EXTI0_IRQHandler:           
    EXTI1_IRQHandler:           
    EXTI2_IRQHandler:           
    EXTI3_IRQHandler:           
    EXTI4_IRQHandler:           
    DMA1_Channel1_IRQHandler:   
    DMA1_Channel2_IRQHandler:   
    DMA1_Channel3_IRQHandler:   
    DMA1_Channel4_IRQHandler:   
    DMA1_Channel5_IRQHandler:   
    DMA1_Channel6_IRQHandler:   
    DMA1_Channel7_IRQHandler:   
    ADC1_2_IRQHandler:          
    USB_HP_CAN1_TX_IRQHandler:   
    USB_LP_CAN1_RX0_IRQHandler: 
    CAN1_RX1_IRQHandler:        
    CAN1_SCE_IRQHandler:        
    EXTI9_5_IRQHandler:         
    TIM1_BRK_IRQHandler:        
    TIM1_UP_IRQHandler:         
    TIM1_TRG_COM_IRQHandler:
    TIM1_CC_IRQHandler:         
    TIM2_IRQHandler:            
    TIM3_IRQHandler:            
    TIM4_IRQHandler:            
    I2C1_EV_IRQHandler:         
    I2C1_ER_IRQHandler:         
    I2C2_EV_IRQHandler:         
    I2C2_ER_IRQHandler:         
    SPI1_IRQHandler:            
    SPI2_IRQHandler:            
    USART1_IRQHandler:          
    USART2_IRQHandler:          
    USART3_IRQHandler:          
    EXTI15_10_IRQHandler:       
    RTCAlarm_IRQHandler:
    USBWakeUp_IRQHandler:       
    b .

    .end
