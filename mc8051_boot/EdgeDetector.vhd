library ieee ;
    use ieee.std_logic_1164.all ;

entity EdgeDetector is
    port (
        Clock   :   in  std_logic;
        Reset   :   in  std_logic;
        SignalDetect    :   in  std_logic;
        RisingEdgeDet       :   out std_logic;
		FallingEdgeDet      :   out std_logic
    ) ;
end EdgeDetector ; 

architecture Arch of EdgeDetector is
    type State is (Init,Zero,FallingEdge,RisingEdge,One);
    signal CurrState: State := Zero;
    signal NextState: State := Zero;
begin
    StateMemory : process( Clock )
    begin
        if Clock'event and Clock = '1' then
            if Reset = '1' then
                CurrState <= Init;
            else
                CurrState <= NextState;
            end if ;
        end if ;
    end process ; -- StateMemory

    NextStateCLC : process(CurrState,SignalDetect)
    begin
        NextState <= CurrState;
        case( CurrState ) is
			When Init =>
				if SignalDetect = '1' then
					NextState <= One;
				else
					NextState <= Zero;
				end if;
				
            when Zero =>
                if SignalDetect = '1' then
                    NextState <= RisingEdge;
                end if ;

            when FallingEdge => 
                NextState <= Zero;
				
			when RisingEdge =>
				NextState <= One;

            when One =>
                if SignalDetect = '0' then
                    NextState <= FallingEdge;
                end if ;

            when others =>
                NextState <= Init; 
        end case ;
    end process ; -- NextStateCLC

    --Output CLC--
    RisingEdgeDet <= '1' when CurrState = RisingEdge else
							'0';
	FallingEdgeDet <=  '1' when CurrState = RisingEdge else
							 '0';

end architecture ;