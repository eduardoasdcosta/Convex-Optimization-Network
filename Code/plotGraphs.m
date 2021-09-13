function plotGraphs(R, nLinks, nFlows)

    A = zeros(nLinks, nLinks, nFlows);
    
    %creates one adjacency matrix for every different instance of flow (nFlows matrices)
    %the flow routes follow an arbitrary path, starting from the lower node to the upper, since the order of the visited nodes doesn't matter
    for i = 1:nFlows
        oldV = 0;
        for j = 1:nLinks
            if (R(j, i) == 1)
                newV = j;
                if (oldV ~= 0)
                    A(oldV, newV, i) = 1;
                    A(newV, oldV, i) = 1;
                end
                oldV = newV;
            end
        end
    end
    
    %plot the multiple flows on a single figure
    figure(2);
    title({"Representation of the network with " + num2str(nLinks) + " links and " + num2str(nFlows) + " flows";
        "Each node is a link, each color of an edge correponds to a flow"});
    hold on;
    
    for i = 1:nFlows
        g = graph(A(:,:,i));
        h = plot(g, 'LineStyle', ':', 'LineWidth', 4, 'MarkerSize', 6, 'NodeColor', 'k', 'NodeLabel', {}, 'layout', 'circle');
        
        %makes sure that every graph has the nodes placed in the same place
        if(i == 1)
            preSet = h;
        else
            h.XData = preSet.XData;
            h.YData = preSet.YData;
            h.NodeLabel={};
        end
    end
    axis off;
    hold off;
end

